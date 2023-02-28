#!/bin/bash
set -e

gh release create v"$1" "./build/YourSchool.ipa#" -t "$2" -n "$3" --latest
rm YourSchool.json
touch YourSchool.json
./build.sh
git add build/YourSchool.ipa
git commit -m "rebuild"
python3 release.py "$1" "$3"
git add YourSchool.json
git commit -m "Repo Update"
git push
