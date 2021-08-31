# syntax=docker/dockerfile:1.3-labs
# Needs BuildKit to enabled to build
# https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md
#
# https://github.com/sgan81/apfs-fuse

FROM debian:10 AS base

FROM base AS git
RUN apt update && apt install -y git

## Clone repos
FROM git AS source
WORKDIR /source
RUN git clone https://github.com/sgan81/apfs-fuse.git /source
RUN git submodule init && git submodule update

FROM base AS build-base
RUN <<eot sh -e
	apt update
	apt install -y \
		bzip2 \
		ccache \
		cmake \
		fuse \
		g++ \
		libattr1-dev \
		libbz2-dev \
		libfuse3-dev \
		zlib1g-dev
eot

FROM build-base AS build
# Enable ccache
ENV PATH="/usr/lib/ccache:${PATH}"
ENV CCACHE_DIR="/ccache"

WORKDIR /build
RUN --mount=type=bind,from=source,target=/source,source=/source <<eot sh -e
	cmake /source
	make -j$(nproc)
eot

RUN --mount=type=bind,from=source,target=/source,source=/source <<eot sh -e
	make install DESTDIR=/out
	strip /out/usr/local/bin/*
eot
WORKDIR /out

FROM scratch AS out
COPY --from=build /out/usr/local/bin/* /
