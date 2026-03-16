#!/bin/bash

PORT="${1:-8000}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR" || exit 1

pick_target_file() {
  for file in "website.html" "FlowVoice Demo.html" "websitebackup.html" "appconcept.html"; do
    if [ -f "$file" ]; then
      printf '%s\n' "$file"
      return 0
    fi
  done

  find . -maxdepth 1 -type f \( -name "*.html" -o -name "*.htm" \) | sed 's#^./##' | head -n 1
}

TARGET_FILE="$(pick_target_file)"

if [ -z "$TARGET_FILE" ]; then
  echo "No HTML file found in $SCRIPT_DIR"
  exit 1
fi

if lsof -ti tcp:"$PORT" >/dev/null 2>&1; then
  echo "Port $PORT is already in use. Stopping existing process."
  lsof -ti tcp:"$PORT" | xargs kill -9
  sleep 1
fi

TARGET_URL_PATH="${TARGET_FILE// /%20}"
TARGET_URL="http://localhost:$PORT/$TARGET_URL_PATH?v=$(date +%s)"

echo "Serving $TARGET_FILE on $TARGET_URL"
(sleep 1 && open "$TARGET_URL") &

exec python3 -m http.server "$PORT"
