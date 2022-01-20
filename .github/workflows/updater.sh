#!/bin/bash

#=================================================
# PACKAGE UPDATING HELPER
#=================================================

# This script is meant to be run by GitHub Actions
# The YunoHost-Apps organisation offers a template Action to run this script periodically
# Since each app is different, maintainers can adapt its contents so as to perform
# automatic actions when a new upstream release is detected.

#=================================================
# FETCHING LATEST RELEASE AND ITS ASSETS
#=================================================

# Fetching information
current_version=$(cat manifest.json | jq -j '.version|split("~")[0]')
current_project_version=$(grep -Po 'project_version="\K[^"]*' scripts/_common.sh)
core_repo=$(cat manifest.json | jq -j '.upstream.code|split("https://github.com/")[1]')
project_repo="flarum/flarum"
# Some jq magic is needed, because the latest upstream release is not always the latest version (e.g. security patches for older versions)
# Core version may be higher than project version, and we actually download the project then perform Composer install.
version=$(curl --silent "https://api.github.com/repos/$core_repo/releases" | jq -r '.[] | select( .prerelease != true ) | .tag_name' | sort -V | tail -1)
project_version=$(curl --silent "https://api.github.com/repos/$project_repo/releases" | jq -r '.[] | select(.tag_name<="'$version'") | .tag_name' | sort -V | tail -1)

# Later down the script, we assume the version has only digits and dots
# Sometimes the release name starts with a "v", so let's filter it out.
# You may need more tweaks here if the upstream repository has different naming conventions.
if [[ ${version:0:1} == "v" || ${version:0:1} == "V" ]]; then
    version=${version:1}
fi
if [[ ${current_project_version:0:1} == "v" || ${current_project_version:0:1} == "V" || ${current_project_version:0:1} == "~" ]]; then
    current_project_version=${current_project_version:1}
fi
if [[ ${project_version:0:1} == "v" || ${project_version:0:1} == "V" || ${project_version:0:1} == "~" ]]; then
    project_version=${project_version:1}
fi

# Setting up the environment variables
echo "Current version: $current_version"
echo "Latest release from upstream: $version"
echo "VERSION=$version" >> $GITHUB_ENV
# For the time being, let's assume the script will fail
echo "PROCEED=false" >> $GITHUB_ENV

# Proceed only if the retrieved version is greater than the current one
if ! dpkg --compare-versions "$current_version" "lt" "$version" ; then
    echo "::warning ::No new version available"
    exit 0
# Proceed only if a PR for this new version does not already exist
elif git ls-remote -q --exit-code --heads https://github.com/$GITHUB_REPOSITORY.git ci-auto-update-v$version ; then
    echo "::warning ::A branch already exists for this update"
    exit 0
fi

#=================================================
# UPDATE SOURCE FILES
#=================================================

# Proceed only if the retrieved version is greater than the current one
if dpkg --compare-versions "$current_project_version" "lt" "$project_version" ; then

asset_url="https://github.com/flarum/flarum/archive/${project_version}.zip"
src="app"
extension="zip"

# Create the temporary directory
tempdir="$(mktemp -d)"

# Download sources and calculate checksum
filename=${asset_url##*/}
curl --silent -4 -L $asset_url -o "$tempdir/$filename"
checksum=$(sha256sum "$tempdir/$filename" | head -c 64)

# Delete temporary directory
rm -rf $tempdir

# Rewrite source file
cat <<EOT > conf/$src.src
SOURCE_URL=$asset_url
SOURCE_SUM=$checksum
SOURCE_SUM_PRG=sha256sum
SOURCE_FORMAT=$extension
SOURCE_IN_SUBDIR=true
EOT
echo "conf/$src.src updated"

else

echo "No need to update conf/$src.src"

fi

#=================================================
# SPECIFIC UPDATE STEPS
#=================================================

sed -i "/project_version=/c\project_version=\"$project_version\"" scripts/_common.sh
echo "scripts/_common.sh patched"

#=================================================
# GENERIC FINALIZATION
#=================================================

# Replace new version in manifest
echo "$(jq -s --indent 4 ".[] | .version = \"$version~ynh1\"" manifest.json)" > manifest.json

# No need to update the README, yunohost-bot takes care of it

# The Action will proceed only if the PROCEED environment variable is set to true
echo "PROCEED=true" >> $GITHUB_ENV
exit 0

