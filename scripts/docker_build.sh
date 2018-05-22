#!/usr/bin/env sh

set -e

docker build -t shyftnetwork/shyft_solidity:build -f scripts/Dockerfile .
tmp_container=$(docker create shyftnetwork/shyft_solidity:build sh)
mkdir -p upload
docker cp ${tmp_container}:/usr/bin/solc upload/solc-static-linux
