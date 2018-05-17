#!/usr/bin/env sh

set -e

echo Attempting to log in to docker. Username is $DOCKER_USERNAME Passowrd is $DOCKER_PASSWORD 
#docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD";
docker login -u="alexatshyft" -p="Z3bBMaA/7cqBjPorFRhInz8gs+C21ysRtdErC3yVxSCueM5ri8t0KnmX9XzPVh+ulX10qDS8bN7gokQ2jjTiB3+KB2+QgFnffNHWqitiragtb0pRrg0HqG0rdFdZg545S4sWzYAo4vaOWtSpP5yfcyW93LOGcmqGPEED/3KpxE8Qm7HFNs496gh9vBm8/2rNr2rqDG8GxoV+gIPsADs4HaWADRaOjEvwZZpXIubqPQH8KKqULrgtJbLHMjwVUXYyGgZR5gBBTJ2a4kLSd+Kyk6El6UT2rFCrycpjlYbcz0F09atLxYdfv1BPLAcHJFGlFDxoMc/Do7hZzepnTRYZvj57XAMt/yS1G1pGh6lCCj7YQdoGr6zdsRa7ynGAl89h0+6qi38z4WLGqEJZ4aYGj05f+LE+vghfO7Ku8KenOUXWVnKX4Xvhwze8xAK3p/lW2UwNdCmkWwwfeIY2JJP/zScrluZb07dEQhP1cFVTJ+eIGyfeGcLfpGwgVIIQAZhXbL2POJiHi68pajoAjlXXrqOQ5FR9ldijx+FEN4AVpZBjgoUC0dSFLHuP0uSVsSK8QIE9HagpT212Xgc/S48XmhPaMg6j3XfkP6yr/irIuEKessXyB7h/95deGwWfey+YYLZykp6EdQmvPW6AhagwP61QFZD9efyGS+Ovlw6IQAI=";
echo Managed to log in to docker username $DOCKER_USERNAME and this is the password $DOCKER_PASSWORD
version=$($(dirname "$0")/get_version.sh)
if [ "$TRAVIS_BRANCH" = "develop" ]
then
    docker tag ethereum/solc:build ethereum/solc:nightly;
    docker tag ethereum/solc:build ethereum/solc:nightly-"$version"-"$TRAVIS_COMMIT"
    docker push ethereum/solc:nightly-"$version"-"$TRAVIS_COMMIT";
    docker push ethereum/solc:nightly;
elif [ "$TRAVIS_TAG" = v"$version" ]
then
#    docker tag ethereum/solc:build ethereum/solc:stable;
#    docker tag ethereum/solc:build ethereum/solc:"$version";
#    docker push ethereum/solc:stable;
#    docker push ethereum/solc:"$version";

    docker tag ethereum/solc:build ethereum/solc:stable;
    docker tag ethereum/solc:build ethereum/solc:"$version";
    docker push ethereum/solc:stable;
    docker push ethereum/solc:"$version";
else
    echo "Not publishing docker image from branch $TRAVIS_BRANCH or tag $TRAVIS_TAG"
fi
