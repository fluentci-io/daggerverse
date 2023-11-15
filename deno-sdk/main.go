package main

import (
	"path"
	"path/filepath"
)

type DenoSdk struct{}

const (
	ModSourceDirPath      = "/src"
	RuntimeExecutablePath = "/usr/local/bin/runtime"
)

type RuntimeOpts struct {
	SubPath  string   `doc:"Sub-path of the source directory that contains the module config."`
	Platform Platform `doc:"Platform to build for."`
}

func (m *DenoSdk) ModuleRuntime(modSource *Directory, opts RuntimeOpts) *Container {
	modSubPath := filepath.Join(ModSourceDirPath, opts.SubPath)
	return m.Base(opts.Platform).
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

func (m *DenoSdk) Codegen(modSource *Directory, opts RuntimeOpts) *GeneratedCode {
	base := m.Base(opts.Platform).
		WithMountedDirectory(ModSourceDirPath, modSource).
		WithWorkdir(path.Join(ModSourceDirPath, opts.SubPath))

	codegen := base.
		WithExec([]string{"sh", "-c", "codegen --module . --propagate-logs --lang nodejs"}, ContainerWithExecOpts{
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

func (m *DenoSdk) CodegenBin(platform Platform) *File {
	return m.denoBase(platform).
		WithMountedDirectory("/sdk", dag.Host().Directory(".")).
		WithExec([]string{"ls", "-lha", "/sdk"}).
		File("/sdk/codegen")
}

func (m *DenoSdk) Base(platform Platform) *Container {
	return m.denoBase(platform).
		WithDirectory("/sdk", dag.Host().Directory(".")).
		WithFile("/usr/bin/codegen", m.CodegenBin(platform))
}

func (m *DenoSdk) denoBase(platform Platform) *Container {
	opts := ContainerOpts{}
	if platform != "" {
		opts.Platform = platform
	}
	return dag.Container(opts).
		From("denoland/deno:alpine-1.37.0").
		WithExec([]string{"apk", "add", "--no-cache", "git"}).
		WithMountedCache("/deno-dir", dag.CacheVolume("moddenocache"))
}
