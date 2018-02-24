#!/bin/bash

# Setting -e and -v as pert https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
# -e: immediately exit if any command has a non-zero exit status
# -v: print all lines in the script before executing them
# -o: prevents errors in a pipeline from being masked
set -euo pipefail

# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
IFS=$'\n\t'

appName=themeparks-dev
LUIS_LOCATION=northeurope
LUIS_KEY=
file="../luis.json"

curl -v -X POST "https://$LUIS_LOCATION.api.cognitive.microsoft.com/luis/api/v2.0/apps/import?appName=$appName" \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $LUIS_KEY" \
--data-binary "@$file"

# TODO Create keys for $LUIS_LOCATION AND $LUIS_KEY
# TODO make scripts executable in git.
# ./deploy-luis-application.sh -a "themeparks-dev" -l $LUIS_LOCATION -k $LUIS_KEY -f "../luis.json"