#!/usr/bin/env bash
# Copy the current Zed selection to the clipboard with its file path and line
# range appended, e.g.:
#
#     <selected code>
#
#     src/foo/bar.ts:12-34
#
# Zed only exposes the cursor row (ZED_ROW), not the selection's start/end, so
# we derive the line range from the selected text. This assumes a top-to-bottom
# selection (cursor at the bottom), which is the common case.

set -euo pipefail

text="${ZED_SELECTED_TEXT:-}"
file="${ZED_RELATIVE_FILE:-${ZED_FILE:-unknown}}"
row="${ZED_ROW:-0}"

if [[ -z "$text" ]]; then
  # No selection: just copy the file:line of the cursor.
  printf '%s:%s\n' "$file" "$row" | pbcopy
  exit 0
fi

# Count newline characters in the selection.
only_newlines="${text//[!$'\n']/}"
nl=${#only_newlines}

if [[ "$text" == *$'\n' ]]; then
  # Selection ends with a newline: cursor sits on the next (empty) line.
  span=$nl
  end=$((row - 1))
else
  span=$((nl + 1))
  end=$row
fi

start=$((end - span + 1))
(( start < 1 )) && start=1

if [[ "$start" == "$end" ]]; then
  loc="$file:$start"
else
  loc="$file:$start-$end"
fi

printf '%s\n\n%s\n' "$text" "$loc" | pbcopy
