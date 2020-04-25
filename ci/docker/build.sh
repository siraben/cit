#!/bin/bash

set -e


USER="melg8"
VERSION="0.0.2"
TARGETS=('hadolint_builder' 'go_builder' 'cit')
DOCKER_PATH="./ci/docker/docker_files"
DOCKER_FILE=${DOCKER_PATH}/"Dockerfile"

export DOCKER_BUILDKIT=1
export DOCKER_CONTENT_TRUST=1

for i in "${!TARGETS[@]}"; do
  TARGET="${TARGETS[i]}"

  TARGET_WITH_CACHE=(--target "${TARGET}")
    for ((j=0; j <= i; j++)); do
      TARGET_WITH_CACHE+=(--cache-from "${TARGETS[j]}")
    done
   COMMAND=(build
            --pull \
            --file "${DOCKER_FILE}" \
            "${TARGET_WITH_CACHE[@]}"
            --tag "${USER}"/"${TARGET}":"${VERSION}" \
            "${DOCKER_PATH}")
   docker "${COMMAND[@]}"
done
