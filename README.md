# PWServer

Server Source Code Repository

## Build Requirements:
- Ubuntu 20 (recommended; use WSL/Docker on Windows)
- gcc9.3 
- libxml-dom-perl
- libxml2-dev:i386
- libssl-dev:i386
- libpcre3-dev:i386
- libssl1.0-dev:i386
- make
## To install i386 packages in Ubuntu
- sudo dpkg --add-architecture i386
- sudo apt update
## To install libssl1.0-dev:i386 in Ubuntu
- Add the following source to aptitude source list.
- - deb http://security.ubuntu.com/ubuntu bionic-security main
    
## Build safely

Run the commands below from the repository root inside Ubuntu/WSL. Do not build from
PowerShell or from a Windows checkout where Linux symlinks are unavailable.

```bash
make configure
make -j1
```

`make configure` updates `cgame/Rules.make`, creates the generated symlinks and
`iolib` directory, and does not remove regular files. `make` builds the binaries
but does not install or strip them.

## Optional install

Review the `install` target in `Makefile` first, then run:

```bash
make install
```
