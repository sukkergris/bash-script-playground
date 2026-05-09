#!/usr/bin/env bash

echo "BASH_SOURCE[0] = ${BASH_SOURCE[0]}"
echo "dirname = $(dirname "${BASH_SOURCE[0]}")"

cd "$(dirname "${BASH_SOURCE[0]}")" && echo "pwd = $(pwd)"
