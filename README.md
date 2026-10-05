# PWServer

Server Source Code Repository

## Build Requirements:
- Ubuntu 20 (recommended; use WSL/Docker on Windows)
- gcc9.3 
- libxml-dom-perl
- libxml2-dev:i386
- libssl-dev:i386
- libpcre3-dev:i386
- make
## Build safely

Run the commands below from the repository root inside Ubuntu/WSL. Do not build from
PowerShell or from a Windows checkout where Linux symlinks are unavailable.

```bash
bash ./install-deps.sh       # first time only
bash ./build-package.sh
```

`make configure` updates `cgame/Rules.make`, creates the generated symlinks and
`iolib` directory, and does not remove regular files. `make` builds the binaries
but does not install or strip them. `build-package.sh` also creates one archive at
`dist/PWServer-<commit>.tar.gz`; it contains only built ELF executables/shared
libraries, not source files or object files.

To run the steps manually:

```bash
make configure
make package
```

## Optional install

Review the `install` target in `Makefile` first, then run:

```bash
make install
```
