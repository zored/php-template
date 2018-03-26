#!/usr/bin/env bash

if [[ "$#" != 4 ]]; then
    cat <<X
Example:
./init.sh \\
    'telegram' \\
    'Telegram' \\
    'PHP Telegram API' \\
    'Easy to use API for Telegram'
X
    exit 1
fi

set -xe

name="$1" namespace="$2" displayName="$3" description="$4"

mv .idea/XXX.iml .idea/$name.iml

# Remove note from README:
tail -n +2 README.md > README.md.tmp
mv README.md.tmp README.md

# Rename occurrences:
replace () {
    for file in $(find * .idea -type f -follow -print); do
        # Replace in file without backup $1 -> $2:
        sed -i '' -e "s/$1/$2/g" $file
    done
}
replace '%NAME%' "$name"
replace '%NAMESPACE%' "$namespace"
replace '%DISPLAY_NAME%' "$displayName"
replace '%DESCRIPTION%' "$description"


cat <<X
GitHub integrations: https://github.com/zored/$name/settings/installations
- Travis: https://travis-ci.org/profile/zored
- Packagist: https://packagist.org/packages/submit

Side checks:
- Scrutinizer: https://scrutinizer-ci.com/g/new
- Coverage: https://coveralls.io/repos/new
- AppVeyour: https://ci.appveyor.com/projects/new
X

# Update Git root:
rm -rf .git
git init
git remote add origin git@github.com:zored/$name.git
rm -- "$0"
git add .
git commit -am "Created from zored/php-template."

if [[ $(curl --silent -I https://github.com/zored/$name | head -n1) != 'HTTP/1.1 200 OK' ]]; then
    echo "Repo not found: push after creation."
    exit 2
fi
git push