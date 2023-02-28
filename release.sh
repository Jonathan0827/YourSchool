#!/bin/bash
set -e

gh release create v"$1" "./build/YourSchool.ipa#" -t "$2" -n "$3" --latest
rm YourSchool.json
touch YourSchool.json
echo '{
    "META": {
        "repoName": "YourSchool Repo",
        "repoIcon": "https://jonathan.kro.kr/YourSchool/icon.png"
    },
    "App": [{
        "name": "YourSchool",
        "version": ""${1}"",
        "icon": "https://jonathan.kro.kr/YourSchool/icon.png",
        "down": "https://jonathan.kro.kr/YourSchool/build/YourSchool.ipa",
        "description": "Unofficial app for Wonsinheung Middle School.",
        "bundleID": "com.junehyeop.YourSchool",
        "category": "App",
        "changelog": "- "${3}""
    }]
}' > YourSchool.json
git add YourSchool.json
git commit -m "Repo Update"
git push
