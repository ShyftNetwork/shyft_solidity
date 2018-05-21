#!/usr/bin/env sh

set -e

docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
version=$($(dirname "$0")/get_version.sh)
if [ "$TRAVIS_BRANCH" = "develop" ]
then
    docker tag alexatshyft/solc:build alexatshyft/solc:nightly;
    docker tag alexatshyft/solc:build alexatshyft/solc:nightly-"$version"-"$TRAVIS_COMMIT"
    docker push alexatshyft/solc:nightly-"$version"-"$TRAVIS_COMMIT";
    docker push alexatshyft/solc:nightly;
elif [ "$TRAVIS_TAG" = v"$version" ]
then
    docker tag alexatshyft/solc:build alexatshyft/solc:stable;
    docker tag alexatshyft/solc:build alexatshyft/solc:"$version";
    docker push alexatshyft/solc:stable;
    docker push alexatshyft/solc:"$version";
else
    echo "Not publishing docker image from branch $TRAVIS_BRANCH or tag $TRAVIS_TAG"
fi

