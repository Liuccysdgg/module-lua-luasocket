#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

mkdir target -p
mkdir build -p
cd build
cmake ..
make
pwd
cp -f mime.so ../target/mime
cp -f serial.so ../target/socket
cp -f socket.so ../target/socket
cp -f unix.so ../target/socket
