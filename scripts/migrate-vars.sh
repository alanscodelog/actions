#!/usr/bin/env bash
# Migrate secrets to vars for a single repo.
# Usage: ./scripts/migrate-vars.sh owner/repo
#
# Prompts for each variable value, creates the var, then deletes the old secret.

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage: $0 owner/repo"
  echo "Example: $0 witchcraftjs/nuxt-logger"
  exit 1
fi

REPO="$1"

echo "Migrating secrets → vars for repo: $REPO"
echo ""

# Variables to migrate (name: default)
declare -A VAR_DEFAULTS=(
  ["USE_LOCKFILE"]="true"
  ["ENABLE_DOCS"]="true"
  ["ENABLE_RELEASE"]="true"
)

for VAR_NAME in "USE_LOCKFILE" "ENABLE_DOCS" "ENABLE_RELEASE"; do
  # Check if the secret exists
  EXISTS=$(gh secret list -R "$REPO" --json name -q ".[] | select(.name == \"$VAR_NAME\") | .name" 2>/dev/null || true)

  if [ -z "$EXISTS" ]; then
    echo "  ⏭  $VAR_NAME: secret not found, skipping"
    continue
  fi

  DEFAULT="${VAR_DEFAULTS[$VAR_NAME]}"
  read -r -p "  $VAR_NAME (default: $DEFAULT)? " VALUE
  VALUE="${VALUE:-$DEFAULT}"

  echo "    → setting var $VAR_NAME = $VALUE"
  gh variable set "$VAR_NAME" -b "$VALUE" -R "$REPO"

  gh secret delete "$VAR_NAME" -R "$REPO"
  echo "    ✓ migrated"
done

# Remove NPM_TOKEN if it exists
EXISTS=$(gh secret list -R "$REPO" --json name -q ".[] | select(.name == \"NPM_TOKEN\") | .name" 2>/dev/null || true)

if [ -n "$EXISTS" ]; then
  echo ""
  read -r -p "  NPM_TOKEN found. Remove it? (y/N) " ANSWER
  if [ "$ANSWER" = "y" ] || [ "$ANSWER" = "Y" ]; then
    gh secret delete NPM_TOKEN -R "$REPO"
    echo "    ✓ removed NPM_TOKEN"
  else
    echo "    ⏭  keeping NPM_TOKEN"
  fi
else
  echo "  ⏭  NPM_TOKEN: not found, skipping"
fi

echo ""
echo "Done. Review at: https://github.com/$REPO/settings/variables/actions"
