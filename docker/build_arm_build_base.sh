#!/usr/bin/env bash
set -e
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

TAG=dessalines/musl-rust-builder:latest

sudo docker build . -f Dockerfile.base-arm -t "$TAG" --platform=linux/arm64

pushd ..
sudo docker build . \
    -f docker/Dockerfile \
    --build-arg BASE_IMAGE="dessalines/musl-rust-builder:latest" \
    --build-arg CARGO_BUILD_TARGET=aarch64-unknown-linux-musl \
    --build-arg RUST_RELEASE_MODE=debug \
    -t "dessalines/lemmy:dev" \
    --platform=linux/arm64
