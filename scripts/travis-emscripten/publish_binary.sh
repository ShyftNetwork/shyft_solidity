#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script for publishing Solidity Emscripten binaries to Github.
#
# The results are committed to https://github.com/ethereum/solc-bin.
#
# The documentation for solidity is hosted at:
#
# http://solidity.readthedocs.io/
#
# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016 solidity contributors.
#------------------------------------------------------------------------------

set -e
echo "Alex -6"

VER=$(cat CMakeLists.txt | grep 'set(PROJECT_VERSION' | sed -e 's/.*set(PROJECT_VERSION "\(.*\)".*/\1/')
echo "Alex -5"
test -n "$VER"
echo "Alex -4"
VER="v$VER"
echo "Alex -3"
COMMIT=$(git rev-parse --short=8 HEAD)
# remove leading zeros in components - they are not semver-compatible
echo "Alex -2"
DATE=$(date --date="$(git log -1 --date=iso --format=%ad HEAD)" --utc +%Y.%-m.%-d)

# remove leading zeros in components - they are not semver-compatible
echo "Alex -1"
COMMIT=$(echo "$COMMIT" | sed -e 's/^0*//')
echo This is ENCRYPTION_LABEL $ENCRYPTION_LABEL  
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
echo This is ENCRYPTED_KEY_VAR $ENCRYPTED_KEY_VAR  
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
echo This is ENCRYPTED_IV_VAR $ENCRYPTED_IV_VAR  
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
echo "Alex 4"
echo This is the ENCRYPTED_IV: $ENCRYPTED_KEY
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
echo This is the ENCRYPTED_IV: $ENCRYPTED_IV
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in scripts/travis-emscripten/deploy_key.enc -out deploy_key -d
echo "Alex 6"
chmod 600 deploy_key
echo "Alex 7"
eval `ssh-agent -s`
echo "Alex 8"
ssh-add deploy_key
echo "Alex 9"

// Alex Binesh: Replaced this line with the line below: e with: git clone --depth 2 git@github.com:ethereum/solc-bin.git
git clone --depth 2 git@github.com:ShyftNetwork/shyft_solc-bin.git
echo "Alex 10"

cd solc-bin
echo "Alex 11"
git config user.name "travis"
echo "Alex 12"
// Alex Binesh: took out this line and replaced it with the below: git config user.email "chris@ethereum.org"
git config user.email "alex@shyft.network"
echo "Alex 13"
git checkout -B gh-pages origin/gh-pages
echo "Alex 14"
git clean -f -d -x
echo "Alex 15"


FULLVERSION=INVALID
if [ "$TRAVIS_BRANCH" = release ]
then
    # We only want one file with this version
    if ls ./bin/soljson-"$VER+"*.js
    then
      echo "Not publishing, we already published this version."
      exit 0
    fi
    FULLVERSION="$VER+commit.$COMMIT"
elif [ "$TRAVIS_BRANCH" = develop ]
then
    # We only want one release per day and we do not want to push the same commit twice.
echo "Alex 16"
    if ls ./bin/soljson-"$VER-nightly.$DATE"*.js || ls ./bin/soljson-*"commit.$COMMIT.js"
    then
echo "Alex 17"
      echo "Not publishing, we already published this version today."
      exit 0
    fi
    FULLVERSION="$VER-nightly.$DATE+commit.$COMMIT"
else
echo "Alex 18"
    echo "Not publishing, wrong branch."
    exit 0
fi


NEWFILE=./bin/"soljson-$FULLVERSION.js"

# Prepare for update script
npm install
echo "Alex 19"

# This file is assumed to be the product of the build_emscripten.sh script.
cp ../soljson.js "$NEWFILE"
echo "Alex 20"

# Run update script
npm run update
echo "Alex 1"

# Publish updates
git add "$NEWFILE"
echo "Alex 21"
git commit -a -m "Added compiler version $FULLVERSION"
echo "Alex 22"
git push origin gh-pages
echo "Alex 23"
