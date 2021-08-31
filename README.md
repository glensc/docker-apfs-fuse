# Build apfs-fuse for Debian 10 (Buster)

Builds [apfs-fuse] using Docker buildx. So this is cross plartform, can compile
on macOS and copy binaries to Linux.

[apfs-fuse]: https://github.com/sgan81/apfs-fuse

## Building

You need [docker buildx][buildx] to build.

With BuildKit enabled `docker build` is known to work as well.

[buildx]: https://docs.docker.com/buildx/working-with-buildx/

```shell
docker buildx build . -o out
```

The resulting binaries are copied to directory "out".

To build for a different platform:

```shell
docker buildx . -o out-arm --platform=linux/arm
```

## Installing

Copy the `apfsutil`, `apfs-fuse` files to target Linux, for example `/usr/local/bin`.

And install dependeant libfuse library:

```
apt update && apt install libfuse3-3
```
