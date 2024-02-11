package main

import (
	"context"
	"fmt"
	"path"
	"path/filepath"
)

func New(
	// +optional
	sdkSourceDir *Directory,
) *DenoSdk {
	return &DenoSdk{
		SDKSourceDir: sdkSourceDir,
	}
}

type DenoSdk struct {
	SDKSourceDir *Directory
}

const (
	ModSourceDirPath      = "/src"
	RuntimeExecutablePath = "/usr/local/bin/runtime"
	schemaPath            = "/schema.json"
	codegenVersion        = "v0.2.0"
)

func (m *DenoSdk) ModuleRuntime(ctx context.Context, modSource *ModuleSource, introspectionJson string) (*Container, error) {

	subPath, err := modSource.Subpath(ctx)
	if err != nil {
		return nil, fmt.Errorf("could not load module config: %v", err)
	}

	modSubPath := filepath.Join(ModSourceDirPath, subPath)
	return m.Base().
		// Add template directory
		WithMountedDirectory("/opt", dag.CurrentModule().Source().Directory(".")).
		// Mount users' module
		WithMountedDirectory(ModSourceDirPath, modSource.RootDirectory()).
		WithWorkdir(path.Join(ModSourceDirPath, subPath)).
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
			"https://cdn.jsdelivr.net/gh/fluentci-io/daggerverse@52c681b/deno-sdk/sdk/src/mod/cli.ts",
			"-n",
			"runtime",
		}).
		WithWorkdir(ModSourceDirPath).
		WithEntrypoint([]string{RuntimeExecutablePath, "--mod-path", path.Join(ModSourceDirPath, subPath)}).
		WithLabel("io.dagger.module.config", modSubPath), nil
}

func (m *DenoSdk) Codegen(ctx context.Context, modSource *ModuleSource, introspectionJson string) (*GeneratedCode, error) {

	subPath, err := modSource.Subpath(ctx)
	if err != nil {
		return nil, fmt.Errorf("could not load module config: %v", err)
	}

	base := m.Base().
		WithMountedDirectory(ModSourceDirPath, modSource.RootDirectory()).
		WithWorkdir(path.Join(ModSourceDirPath, subPath)).
		WithNewFile(schemaPath, ContainerWithNewFileOpts{
			Contents: introspectionJson,
		})

	codegen := base.
		WithExec([]string{"sh", "-c", "codegen --module . --propagate-logs --lang deno --introspection-json-path /schema.json"}, ContainerWithExecOpts{
			ExperimentalPrivilegedNesting: true,
		}).
		Directory(".")

	return dag.GeneratedCode(codegen), nil
}

func (m *DenoSdk) CodegenBin() *File {
	codegen := "codegen_" + codegenVersion + "_x86_64_unknown_linux-gnu.tar.gz"
	return dag.Container().
		From("alpine:latest").
		WithExec([]string{"wget", "https://github.com/fluentci-io/codegen/releases/download/" + codegenVersion + "/" + codegen}).
		WithExec([]string{"tar", "-xvf", codegen}).
		File("/codegen")
}

func (m *DenoSdk) Base() *Container {
	return m.denoBase().
		WithDirectory("/sdk", dag.CurrentModule().Source().Directory(".")).
		WithFile("/usr/bin/codegen", m.CodegenBin())
}

func (m *DenoSdk) denoBase() *Container {
	opts := ContainerOpts{}
	return dag.Container(opts).
		From("denoland/deno:alpine-1.37.0").
		WithExec([]string{"apk", "add", "--no-cache", "git"}).
		WithMountedCache("/deno-dir", dag.CacheVolume("moddenocache"))
}
