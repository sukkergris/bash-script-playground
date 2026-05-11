#!/usr/bin/env bash
set -Eeuo pipefail

# Global constants for the project

# Name of the file that marks the project root
ROOT_MARKER="root-folder-marker"

# How many directory levels we allow find_root to climb
MAX_ROOT_DEPTH=10
