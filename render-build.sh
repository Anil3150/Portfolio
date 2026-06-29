#!/usr/bin/env bash

set -e

echo "Installing Flutter Stable..."

git clone https://github.com/flutter/flutter.git --depth 1 -b stable

export PATH="$PATH:$(pwd)/flutter/bin"

flutter doctor

flutter config --enable-web

flutter pub get

flutter build web --release