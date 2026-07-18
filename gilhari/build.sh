#!/bin/bash
cd "$(dirname "$0")/.."
docker buildx version >/dev/null 2>&1 || echo "Note: a 'legacy builder is deprecated' warning below (if shown) is harmless."
docker build --platform linux/amd64 -f gilhari/Dockerfile -t excel-poc-service:1.0 .
docker images
