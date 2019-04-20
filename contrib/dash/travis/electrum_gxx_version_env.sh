#!/bin/bash

VERSION_STRING=(`grep ELECTRUM_VERSION electrum_gxx/version.py`)
GXX_ELECTRUM_VERSION=${VERSION_STRING[2]}
GXX_ELECTRUM_VERSION=${GXX_ELECTRUM_VERSION#\'}
GXX_ELECTRUM_VERSION=${GXX_ELECTRUM_VERSION%\'}
export GXX_ELECTRUM_VERSION

APK_VERSION_STRING=(`grep APK_VERSION electrum_gxx/version.py`)
GXX_ELECTRUM_APK_VERSION=${APK_VERSION_STRING[2]}
GXX_ELECTRUM_APK_VERSION=${GXX_ELECTRUM_APK_VERSION#\'}
GXX_ELECTRUM_APK_VERSION=${GXX_ELECTRUM_APK_VERSION%\'}
export GXX_ELECTRUM_APK_VERSION