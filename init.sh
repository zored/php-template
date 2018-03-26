#!/usr/bin/env bash

if [[ "$#" != 4 ]]; then
    cat <<X
Example:
telegram Telegram 'PHP Telegram API' 'Easy to use API for Telegram'
X
    exit 1
fi

name="$1" namespace="$2" displayName="$3" description="$4"

mv .idea/XXX.iml .idea/$name.iml

# Remove note from README:
tail -n +2 README.md > README.md

# Rename occurrences:
replace () {
    find * .idea \
            -type f \
            -follow \
            -print |\
        xargs sed -i -e "s/$1/$2/g"
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