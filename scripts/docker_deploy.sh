#!/usr/bin/env sh

set -e

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
version=$($(dirname "$0")/get_version.sh)
if [ "$TRAVIS_BRANCH" = "develop" ]
then
    docker tag shyftnetwork/shyft_solidity:build shyftnetwork/shyft_solidity:nightly;
    docker tag shyftnetwork/shyft_solidity:build shyftnetwork/shyft_solidity:nightly-"$version"-"$TRAVIS_COMMIT"
    docker push shyftnetwork/shyft_solidity:nightly-"$version"-"$TRAVIS_COMMIT";
    docker push shyftnetwork/shyft_solidity:nightly;
elif [ "$TRAVIS_TAG" = v"$version" ]
then
    docker tag shyftnetwork/shyft_solidity:build shyftnetwork/shyft_solidity:stable;
    docker tag shyftnetwork/shyft_solidity:build shyftnetwork/shyft_solidity:"$version";
    docker push shyftnetwork/shyft_solidity:stable;
    docker push shyftnetwork/shyft_solidity:"$version";
else
    echo "Not publishing docker image from branch $TRAVIS_BRANCH or tag $TRAVIS_TAG"
fi
