#!/usr/bin/env bash
set -euo pipefail

URL="http://127.0.0.1:8000/packages.json"
OUTPUT="summary.md"

curl -fsS "$URL" | \
  jq -r '
    ["| name | version | downloads |", "|------|---------|----------|"] as $header |
    [$header[],
     ([.[] | select(.status == "active" and .downloads >= 100)]
      | sort_by(-.downloads, .name)
      | .[]
      | "| \(.name) | \(.version) | \(.downloads) |")
    ] | .[]' > "$OUTPUT"

# Prepend title
{
  echo "# Package Summary"
  echo ""
  cat "$OUTPUT"
} > "${OUTPUT}.tmp" && mv "${OUTPUT}.tmp" "$OUTPUT"

echo "Report written to $OUTPUT"
