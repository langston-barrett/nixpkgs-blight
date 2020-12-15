# nixpkgs-blight

## tl;dr

`nixpkgs-blight` can instrument the builds of tens of thousands of open-source
packages. This can be used to:

- Record and analyze compiler/linker flags used by open-source projects
- Inject dynamic instrumentation like [ASan][asan] into build processes and run
  the resulting program's test suite
- Build [LLVM][llvm] bitcode instead of normal executables using [gllvm][gllvm]
- Stress test your static analysis tool, compiler, or LLVM pass against
  thousands of real-world programs

## Table of Contents

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [nixpkgs-blight](#nixpkgs-blight)
    - [tl;dr](#tldr)
    - [Table of Contents](#table-of-contents)
    - [What](#what)
    - [Usage](#usage)
        - [Recording a Build Log](#recording-a-build-log)
        - [Building LLVM Bitcode](#building-llvm-bitcode)
    - [How](#how)
    - [Development](#development)
        - [Debugging](#debugging)
        - [Testing](#testing)

<!-- markdown-toc end -->


## What

[`blight`][blight] is a wrapper for C/C++ build tools (`CC`, `CXX`, `LD`, etc.).
Out of the box, it can perform a variety of useful actions:

- Recording flags passed to each tool
- Injecting flags
- Benchmarking builds
- Finding build outputs

[`nixpkgs`][nixpkgs] is a massive, active package repository with extensible,
reproducible builds.

This repo combines the two to allow for reproducible instrumentation of
thousands of open-source packages. Specifically, it provides:

- A Nix expression for `blight`
- A framework for using `blight` inside `nixpkgs` builds that use common build
  tools:
  - [x] Make
  - [ ] CMake
  - [ ] Autotools

## Usage

First, install Make and [Nix][nix].

In all the following examples, `package-name` can be replaced with any package
in `nixpkgs`, e.g. `entr` or `hello`. For a full list, see
```bash
nix eval '(builtins.attrNames (import <nixpkgs> { }))'
```
or
```
nix search "some package"
```
or https://search.nixos.org/packages.

### Recording a Build Log

```bash
make out/instrument/package-name
less out/instrument/package-name/record.jsonl
```

### Building LLVM Bitcode

```bash
make out/bitcode/package-name
```

### Injecting `-Werror`

```bash
make out/inject/package-name
```

## How

For each relevant build system, there is a Nix function that overrides a
derivation to check if that derivation is using that build system, writing the
result to a file in the overriden derivation's output. This can be used in
further Nix expressions to instrument the build system appropriately (for
example, by setting `CC` for Make-based builds, setting `cmakeFlags` for
CMake-based builds, etc.).

After deducing a build system, Nix expressions can override the derivation
again, this time configuring `blight` to do its job.

## Development

PRs welcome!

### Debugging

```bash
make NIXFLAGS="--show-trace --arg debug true"
```

### Testing

- For a package with a Makefile, try `entr`.
- For a package with a CMakeLists.txt, try `yarp`.

[asan]: https://clang.llvm.org/docs/AddressSanitizer.html
[blight]: https://blog.trailofbits.com/2020/11/25/high-fidelity-build-instrumentation-with-blight/
[gllvm]: https://github.com/SRI-CSL/gllvm
[llvm]: https://llvm.org/
[nix]: https://nixos.org/download.html
[nixpkgs]: https://github.com/NixOS/nixpkgs
