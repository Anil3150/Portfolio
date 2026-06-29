#!/usr/bin/env bash

set -e

echo "Installing Flutter..."

git clone https://github.com/flutter/flutter.git --depth 1

export PATH="$PATH:$(pwd)/flutter/bin"

flutter doctor

flutter config --enable-web

echo "Getting packages..."

flutter pub get

echo "Building Flutter Web..."

flutter build web --release