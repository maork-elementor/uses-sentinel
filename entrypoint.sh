#!/bin/bash

YMLS=$(find ./.github/workflows -name "*.yml" -type f)
BAD_VERSIONS=("main" "master" "latest")

BAD_VERSIONS_RESULT=""
NOT_UPDATED_RESULT=""

for yml in $YMLS; do
  USES=$(grep -o 'uses:.*' "$yml" | cut -d' ' -f2)

  for exclude in $EXCLUDE; do
    USES=$(echo "$USES" | grep -v "$exclude")
  done

  for use in $USES; do
    if [[ $use == *"@"* ]]; then
      current_version=$(echo $use | cut -d'@' -f2 | awk '{gsub(/\^\{\}/,""); print}')
      use_without_version=$(echo "$use" | cut -d'@' -f1)
      if [[ " ${BAD_VERSIONS[@]} " =~ " ${current_version} " ]]; then
        BAD_VERSIONS_RESULT+="yml: $yml, use: $use, It is not safe to use ${current_version}\n"
      elif [[ $NOT_UPDATED_RESULT == *"$use_without_version"* ]]; then
        continue
      else
        latest_version=$(git ls-remote --tags "https://github.com/$use_without_version" | awk '{print $2}' | cut -d '/' -f 3 | sort -V | tail -n 1 | awk '{gsub(/\^\{\}/,""); print}')
        if [[ $latest_version != $current_version ]]; then
          NOT_UPDATED_RESULT+="yml: $yml, use: $use current version: $current_version, latest version: $latest_version\n"
        else
          NOT_UPDATED_RESULT+=""
        fi
      fi
    fi
  done
done

if [[ -n $BAD_VERSIONS_RESULT || -n $NOT_UPDATED_RESULT ]]; then
  echo "Some actions are not safe to use or not updated"
  echo ""
  if [[ -n $BAD_VERSIONS_RESULT ]]; then
    echo "Bad versions:"
    echo -e "$BAD_VERSIONS_RESULT"
  fi
  if [[ -n $NOT_UPDATED_RESULT ]]; then
    echo "Not updated actions:"
    echo -e "$NOT_UPDATED_RESULT"
  fi
  exit 1
fi

exit 0
