#!/bin/bash
set -ev

if [[ -z $TRAVIS_TAG ]]; then
  echo TRAVIS_TAG unset, exiting
  exit 1
fi

BUILD_REPO_URL=https://github.com/akhavr/electrum-gxx.git

cd build

git clone --branch $TRAVIS_TAG $BUILD_REPO_URL electrum-gxx

cd electrum-gxx

export PY36BINDIR=/Library/Frameworks/Python.framework/Versions/3.6/bin/
export PATH=$PATH:$PY36BINDIR
source ./contrib/gxx/travis/electrum_gxx_version_env.sh;
echo osx build version is $GXX_ELECTRUM_VERSION


git submodule init
git submodule update

info "Building CalinsQRReader..."
d=contrib/CalinsQRReader
pushd $d
rm -fr build
xcodebuild || fail "Could not build CalinsQRReader"
popd

sudo pip3 install -r contrib/deterministic-build/requirements.txt
sudo pip3 install -r contrib/deterministic-build/requirements-hw.txt
sudo pip3 install -r contrib/deterministic-build/requirements-binaries.txt
sudo pip3 install x11_hash>=1.4
sudo pip3 install PyInstaller==3.4 --no-use-pep517

export PATH="/usr/local/opt/gettext/bin:$PATH"
./contrib/make_locale
find . -name '*.po' -delete
find . -name '*.pot' -delete

cp contrib/gxx/osx.spec .
cp contrib/gxx/pyi_runtimehook.py .
cp contrib/gxx/pyi_tctl_runtimehook.py .

pyinstaller \
    -y \
    --name electrum-gxx-$GXX_ELECTRUM_VERSION.bin \
    osx.spec

info "Adding Dash URI types to Info.plist"
plutil -insert 'CFBundleURLTypes' \
   -xml '<array><dict> <key>CFBundleURLName</key> <string>gxx</string> <key>CFBundleURLSchemes</key> <array><string>gxx</string></array> </dict></array>' \
   -- dist/Dash\ Electrum.app/Contents/Info.plist \
   || fail "Could not add keys to Info.plist. Make sure the program 'plutil' exists and is installed."

sudo hdiutil create -fs HFS+ -volname "Dash Electrum" \
    -srcfolder dist/Dash\ Electrum.app \
    dist/Dash-Electrum-$GXX_ELECTRUM_VERSION-macosx.dmg
