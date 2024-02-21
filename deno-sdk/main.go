package main

import (
	"context"
	"fmt"
	"path"
	"path/filepath"
)

func New(
	// +optional
	_sdkSourceDir *Directory,
) *DenoSdk {
	sdkSourceDir := dag.Git("https://github.com/fluentci-io/daggerverse").Branch("main").Tree()
	return &DenoSdk{
		SDKSourceDir: sdkSourceDir.Directory("./deno-sdk"),
		RequiredPaths: []string{
			"**/deno.json",
			"**/deno.lock",
		},
	}
}

type DenoSdk struct {
	SDKSourceDir  *Directory
	RequiredPaths []string
}

const (
	ModSourceDirPath      = "/src"
	RuntimeExecutablePath = "/usr/local/bin/runtime"
	schemaPath            = "/schema.json"
	codegenVersion        = "v0.2.0"
	sdkSrc                = "/sdk"
	genDir                = "sdk"
)

func (m *DenoSdk) ModuleRuntime(ctx context.Context, modSource *ModuleSource, introspectionJson string) (*Container, error) {

	subPath, err := modSource.SourceSubpath(ctx)
	if err != nil {
		return nil, fmt.Errorf("could not load module config: %v", err)
	}

	modSubPath := filepath.Join(ModSourceDirPath, subPath)
	return m.Base().
		// Add template directory
		WithMountedDirectory("/opt", dag.CurrentModule().Source().Directory(".")).
		// Mount users' module
		WithMountedDirectory(ModSourceDirPath, modSource.ContextDirectory()).
		WithWorkdir(path.Join(ModSourceDirPath, subPath)).
		WithNewFile(schemaPath, ContainerWithNewFileOpts{
			Contents: introspectionJson,
		}).
		WithExec([]string{"sh", "-c", "ls -lha"}).
		WithExec([]string{"sh", "-c", "codegen --module . --propagate-logs --lang deno --introspection-json-path /schema.json"}, ContainerWithExecOpts{
			ExperimentalPrivilegedNesting: true,
		}).
	        WithExec([]string{"sh", "-c", "[ ! -f  '/src/import_map.json' ] && wget -P /src https://cdn.jsdelivr.net/gh/fluent-ci-templates/base-pipeline@main/import_map.json; exit 0"}).
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

	subPath, err := modSource.SourceSubpath(ctx)
	if err != nil {
		return nil, fmt.Errorf("could not load module config: %v", err)
	}

	base := m.Base().
		WithMountedDirectory(ModSourceDirPath, modSource.ContextDirectory()).
		WithWorkdir(path.Join(ModSourceDirPath, subPath)).
		WithNewFile(schemaPath, ContainerWithNewFileOpts{
			Contents: introspectionJson,
		})

	ctr := base.
		WithExec([]string{"sh", "-c", "codegen --module . --propagate-logs --lang deno --introspection-json-path /schema.json"}, ContainerWithExecOpts{
			ExperimentalPrivilegedNesting: true,
		})

	codegen := ctr.WithDirectory(genDir, ctr.Directory(sdkSrc), ContainerWithDirectoryOpts{
		Exclude: []string{},
	}).
		Directory(ModSourceDirPath)

	return dag.GeneratedCode(codegen).
		WithVCSGeneratedPaths([]string{
			genDir + "/**",
		}).
		WithVCSIgnoredPaths([]string{
			genDir,
		}), nil
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
		WithDirectory("/sdk", m.SDKSourceDir).
		WithFile("/usr/bin/codegen", m.CodegenBin())
}

func (m *DenoSdk) denoBase() *Container {
	opts := ContainerOpts{}
	return dag.Container(opts).
		From("denoland/deno:alpine-1.37.0").
		WithExec([]string{"apk", "add", "--no-cache", "git"}).
		WithMountedCache("/deno-dir", dag.CacheVolume("moddenocache"))
}
