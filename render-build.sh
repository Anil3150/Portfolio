#!/usr/bin/env bash

set -e

echo "Installing Flutter 3.29.2..."

git clone https://github.com/flutter/flutter.git --branch 3.29.2 --depth 1

export PATH="$PATH:$(pwd)/flutter/bin"

flutter --version

flutter config --enable-web

echo "Installing dependencies from pubspec.lock..."

flutter pub get --enforce-lockfile

echo "Building..."

flutter build web --release