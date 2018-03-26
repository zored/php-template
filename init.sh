#!/usr/bin/env bash

if [[ "$#" != 4 ]]; then
    cat <<X
Example:
./init.sh \
    'telegram' \
    'Telegram' \
    'PHP Telegram API' \
    'Easy to use API for Telegram'
X
    exit 1
fi

name="$1" namespace="$2" displayName="$3" description="$4"

mv .idea/XXX.iml .idea/$name.iml

# Remove note from README:
tail -n +2 README.md > README.md.tmp
mv README.md.tmp README.md

# Rename occurrences:
replace () {
    for file in $(find * .idea -type f -follow -print); do
        xargs sed -i -e "s/$1/$2/g" $file
    done
}
replace '%NAME%' "$name"
replace '%NAMESPACE%' "$namespace"
replace '%DISPLAY_NAME%' "$displayName"
replace '%DESCRIPTION%' "$description"

cat <<X
Also add GitHub integrations:
https://github.com/zored/$name/settings/installations
- Travis
- Packagist
X