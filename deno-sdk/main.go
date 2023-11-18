package main

import (
	"path"
	"path/filepath"
)

type DenoSdk struct{}

const (
	ModSourceDirPath      = "/src"
	RuntimeExecutablePath = "/usr/local/bin/runtime"
	schemaPath            = "/schema.json"
)

func (m *DenoSdk) ModuleRuntime(modSource *Directory, subPath string, introspectionJson string) *Container {
	modSubPath := filepath.Join(ModSourceDirPath, subPath)
	return m.Base().
		WithDirectory(ModSourceDirPath, modSource).
		WithWorkdir(modSubPath).
		WithExec([]string{"sh", "-c", "ls -lha"}).
		WithExec([]string{"sh", "-c", "codegen --module . --lang nodejs"}, ContainerWithExecOpts{
			ExperimentalPrivilegedNesting: true,
		}).
		WithExec([]string{
			"deno",
			"install",
			"--reload",
			"-A",
			"https://cdn.jsdelivr.net/gh/fluentci-io/daggerverse@main/deno-sdk/sdk/src/mod/cli.ts",
			"-n",
			"runtime",
		}).
		WithWorkdir(ModSourceDirPath).
		WithDefaultArgs().
		WithEntrypoint([]string{RuntimeExecutablePath}).
		WithLabel("io.dagger.module.config", modSubPath)
}

func (m *DenoSdk) Codegen(modSource *Directory, subPath string, introspectionJson string) *GeneratedCode {
	base := m.Base().
		WithMountedDirectory(ModSourceDirPath, modSource).
		WithWorkdir(path.Join(ModSourceDirPath, subPath)).
		WithNewFile(schemaPath, ContainerWithNewFileOpts{
			Contents: introspectionJson,
		})

	codegen := base.
		WithExec([]string{"sh", "-c", "codegen --module . --propagate-logs --lang nodejs --introspection-json-path /schema.json"}, ContainerWithExecOpts{
			ExperimentalPrivilegedNesting: true,
		}).
		Directory(".")

	return dag.GeneratedCode(base.Directory(".").Diff(codegen)).
		WithVCSIgnoredPaths([]string{
			"dagger.gen.go",
			"internal/querybuilder/",
			"querybuilder/", // for old repos
		})
}

func (m *DenoSdk) CodegenBin() *File {
	return m.goBase().
		WithExec([]string{"git", "clone", "https://github.com/fluentci-io/codegen.git"}).
		WithWorkdir("codegen").
		WithExec([]string{"go", "build", "-o", "/usr/bin/codegen"}).
		File("/usr/bin/codegen")
}

func (m *DenoSdk) Base() *Container {
	return m.denoBase().
		WithDirectory("/sdk", dag.Host().Directory(".")).
		WithFile("/usr/bin/codegen", m.CodegenBin())
}

func (m *DenoSdk) denoBase() *Container {
	opts := ContainerOpts{}
	return dag.Container(opts).
		From("denoland/deno:alpine-1.37.0").
		WithExec([]string{"apk", "add", "--no-cache", "git"}).
		WithMountedCache("/deno-dir", dag.CacheVolume("moddenocache"))
}

func (m *DenoSdk) goBase() *Container {
	opts := ContainerOpts{}
	return dag.Container(opts).
		From("golang:1.21-alpine").
		WithExec([]string{"apk", "add", "--no-cache", "git"})
}
