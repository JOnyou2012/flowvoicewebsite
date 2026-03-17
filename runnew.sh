#!/bin/bash

PORT="${1:-8001}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$SCRIPT_DIR" || exit 1

TARGET_FILE="website_new.html"

if [ ! -f "$TARGET_FILE" ]; then
  echo "website_new.html not found in $SCRIPT_DIR"
  exit 1
fi

if lsof -ti tcp:"$PORT" >/dev/null 2>&1; then
  echo "Port $PORT is already in use. Stopping existing process."
  lsof -ti tcp:"$PORT" | xargs kill -9
  sleep 1
fi

TARGET_URL="http://localhost:$PORT/$TARGET_FILE?v=$(date +%s)"

echo "Serving $TARGET_FILE on $TARGET_URL"
(sleep 1 && open "$TARGET_URL") &

exec python3 -m http.server "$PORT"
