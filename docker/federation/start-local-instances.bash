#!/bin/bash
set -e

sudo docker-compose down
num_args=$#;
docker_build_arch="linux/amd64";
i=1;
while [ $i -le $num_args ] 
do
    current_arg=$1;
    case "$1" in
        --build-arch) docker_build_arch=$2;;
        # We only support flags right now.
        *) echo "Invalid argument: $1"; exit 1;;
    esac
    if ! shift 2; then
      echo "Parameter needed for flag: $current_arg"; exit 1;
    fi
  i=$((i + 2));
done

echo "Building with architecture: $docker_build_arch";
case "$docker_build_arch" in
        linux/amd64) sudo docker build ../../ --file ../Dockerfile -t lemmy-federation:latest;;
        linux/arm64) sudo docker build ../.. \
                      -f ../Dockerfile \
                      --build-arg BASE_IMAGE="dessalines/muslrust:1.0.0" \
                      --build-arg CARGO_BUILD_TARGET=aarch64-unknown-linux-musl \
                      -t "lemmy-federation:latest" \
                      --platform=linux/arm64;;
        *) echo "Build architecture not currently supported."; exit 1;;
    esac

for Item in alpha beta gamma delta epsilon ; do
  sudo mkdir -p volumes/pictrs_$Item
  sudo chown -R 991:991 volumes/pictrs_$Item
done

#sudo docker-compose pull --ignore-pull-failures || true
sudo docker-compose up
