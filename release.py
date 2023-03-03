import sys
f = open('YourSchool.json', 'w')
f.write('''
{
    "META": {
        "repoName": "YourSchool Repo",
        "repoIcon": "https://jonathan.kro.kr/YourSchool/icon.png"
    },
    "App": [{
        "name": "YourSchool",
        "version": "'''+sys.argv[1]+'''",
        "icon": "https://jonathan.kro.kr/YourSchool/icon.png",
        "down": "https://jonathan.kro.kr/YourSchool/build/YourSchool.ipa",
        "description": "Unofficial app for Wonsinheung Middle School.",
        "bundleID": "com.junehyeop.YourSchool",
        "category": "App",
        "changelog": "'''+"- "+sys.argv[2]+'''"
    }]
}
''')
