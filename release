#!/bin/bash
set -e
./build.sh
git add ./build/YourSchool.ipa
git commit -m "rebuild"
git push
gh release create v"$1" "./build/YourSchool.ipa#" -t "$2" -n "$3" --latest
rm YourSchool.json
touch YourSchool.json
python3 release.py "$1" "$3"
git add YourSchool.json
git commit -m "Repo Update"
git push
git add .
git commit -m "updated by system"
git push
