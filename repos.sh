#!/bin/bash

set -e
FILE="repos.txt"

[ ! -f "$FILE" ] && echo "❌ Missing $FILE" && exit 1

echo "
##############################
### Essential Repositories ###
##############################
"

while IFS= read -r REPO; do
    [[ -z "$REPO" || "$REPO" =~ ^# ]] && continue
    REPO_NAME=$(basename "$REPO" .git)
    if [ -d "$REPO_NAME" ]; then
        echo " Skipping $REPO_NAME — already exists "
    else
        echo " Cloning $REPO ... "
        git clone "$REPO"
    fi
done < "$FILE"

echo " Done! "

