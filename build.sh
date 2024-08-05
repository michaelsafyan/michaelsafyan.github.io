#! /bin/bash

function Build() {
    local bazel_version=$(cat ./src/.bazelversion)
    local year=$(date +%Y)
    local month=$(date +%m)
    local day=$(date +%d)
    local timestamp=$(date +%s)
    local output_root=$(mktemp -d)
    local output_dir="${output_root}/output/${year}/${month}/${day}/${timestamp}"
    mkdir -p "${output_dir}"
    chmod g+rwx "${output_dir}"
    pushd "${output_dir}"
    local output_dir_abs=$(pwd)
    popd
    docker run \
      -e USER="$(id -u)" \
      -u=$(id -u) \
      -v ./src:/src/workspace:ro \
      -v ${output_dir_abs}:/tmp/build_output:rw \
      -w /src/workspace \
      gcr.io/bazel-public/bazel:${bazel_version} \
     --output_user_root=/tmp/build_output/output build :main
    if [ $? -ne 0  ] ; then
      exit 1
    fi

    local build_artifact=$(find "${output_dir}" -name 'website_tarball.tar')
    if [ -f "${build_artifact}" ] ; then
      cp "${build_artifact}" "./doc/website_tarball.tar"
      pushd "./doc"
      tar -xvf "./website_tarball.tar"
      chmod ug+rwx "./website_tarball.tar"
      rm "./website_tarball.tar"
      popd
    fi
}

Build
