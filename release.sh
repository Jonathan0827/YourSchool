#!/bin/bash
set -e

gh release create v"$1" "./build/YourSchool.ipa#" -t "$2" -n "$3" --latest
