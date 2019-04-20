#!/bin/bash
set -ev

if [[ -z $TRAVIS_TAG ]]; then
  echo TRAVIS_TAG unset, exiting
  exit 1
fi

docker pull zebralucky/electrum-gxx-winebuild:LinuxPy36
docker pull zebralucky/electrum-gxx-winebuild:LinuxAppImage
docker pull zebralucky/electrum-gxx-winebuild:WinePy36
