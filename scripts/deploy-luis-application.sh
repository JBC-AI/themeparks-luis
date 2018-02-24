#!/bin/bash

# Setting -e and -v as pert https://docs.travis-ci.com/user/customizing-the-build/#Implementing-Complex-Build-Steps
# -e: immediately exit if any command has a non-zero exit status
# -v: print all lines in the script before executing them
# -o: prevents errors in a pipeline from being masked
set -euo pipefail

# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)
IFS=$'\n\t'

usage() { echo "Usage: $0 -a <appName> -l <luisLocation> -k <luisKey> -f <applicationJsonFilePath>" 1>&2; exit 1; }

declare appName=""
declare luisLocation=""
declare luisKey=""
declare applicationJsonFilePath=""

# Initialize parameters specified from command line
while getopts ":a:l:k:f:" arg; do
	case "${arg}" in		
		a)
			appName=${OPTARG}
			;;
        l)
			luisLocation=${OPTARG}
			;;
        k)
			luisKey=${OPTARG}
			;;
        f)
			applicationJsonFilePath=${OPTARG}
			;;
		esac
done
shift $((OPTIND-1))

# Prompt for parameters is some required parameters are missing
if [[ -z "$appName" ]]; then
	echo "appName:"
	read appName
	[[ "${appName:?}" ]]
fi

if [[ -z "$luisLocation" ]]; then
	echo "luisLocation:"
	read luisLocation
	[[ "${luisLocation:?}" ]]
fi

if [[ -z "$luisKey" ]]; then
	echo "luisKey:"
	read luisKey
	[[ "${luisKey:?}" ]]
fi

if [[ -z "$applicationJsonFilePath" ]]; then
	echo "applicationJsonFilePath:"
	read applicationJsonFilePath
	[[ "${applicationJsonFilePath:?}" ]]
fi

# Ensuring file exist.
if [ ! -f "$applicationJsonFilePath" ]; then
	echo "$applicationJsonFilePath cannot be found"
	exit 1
fi

url="https://$luisLocation.api.cognitive.microsoft.com/luis/api/v2.0/apps/import?appName=$appName"

curl -v -X POST $url \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $luisKey" \
--data-binary "@$applicationJsonFilePath"