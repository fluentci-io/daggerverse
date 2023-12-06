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
		WithNewFile(schemaPath, ContainerWithNewFileOpts{
			Contents: introspectionJson,
		}).
		WithExec([]string{"sh", "-c", "ls -lha"}).
		WithExec([]string{"sh", "-c", "codegen --module . --propagate-logs --lang deno --introspection-json-path /schema.json"}, ContainerWithExecOpts{
			ExperimentalPrivilegedNesting: true,
		}).
		WithExec([]string{
			"deno",
			"install",
			"--reload",
			"-A",
			"https://cdn.jsdelivr.net/gh/fluentci-io/daggerverse@cbbb176/deno-sdk/sdk/src/mod/cli.ts",
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
		WithExec([]string{"sh", "-c", "codegen --module . --propagate-logs --lang deno --introspection-json-path /schema.json"}, ContainerWithExecOpts{
			ExperimentalPrivilegedNesting: true,
		}).
		Directory(".")

	return dag.GeneratedCode(codegen)
}

func (m *DenoSdk) CodegenBin() *File {
	codegen := "codegen_v0.1.0_x86_64_unknown_linux-gnu.tar.gz"
	return dag.Container().
		From("alpine:latest").
		WithExec([]string{"wget", "https://github.com/fluentci-io/codegen/releases/download/v0.1.0/" + codegen}).
		WithExec([]string{"tar", "-xvf", codegen}).
		File("/codegen")
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
		WithExec([]string{"apk", "add", "--no-cache", "git", "libc6-compat"}).
		WithMountedCache("/deno-dir", dag.CacheVolume("moddenocache"))
}
