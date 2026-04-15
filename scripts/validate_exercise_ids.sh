#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JSON_FILE="$SCRIPT_DIR/../assets/data/exercises.json"

if [ ! -f "$JSON_FILE" ]; then
  echo "Error: exercises.json not found" >&2
  exit 1
fi

# Valid exercise types (storage strings and enum name fallbacks from ExerciseType.fromString)
VALID_TYPES=(
  "einschwimmen"
  "wassergewöhnung"
  "wassergewoehnung"
  "rettungsschwimmen"
  "technik-brust"
  "technikBrust"
  "technik-kraul"
  "technikKraul"
  "technik-rücken"
  "technikRuecken"
  "ausschwimmen"
  "spiel"
  "ausdauer"
  "kraft"
)

errors=0

# Check for duplicate IDs
duplicate_ids=$(jq -r '[.exercises[].id] | group_by(.) | map(select(length > 1) | .[0]) | .[]' "$JSON_FILE")
if [ -n "$duplicate_ids" ]; then
  echo "Error: Duplicate exercise IDs found: $duplicate_ids" >&2
  errors=$((errors + 1))
fi

# Check for invalid types
while IFS=$'\t' read -r id type; do
  valid=false
  for t in "${VALID_TYPES[@]}"; do
    if [ "$type" = "$t" ]; then
      valid=true
      break
    fi
  done
  if [ "$valid" = false ]; then
    echo "Error: Invalid exercise type at id $id: \"$type\"" >&2
    errors=$((errors + 1))
  fi
done < <(jq -r '.exercises[] | [(.id | tostring), .type] | @tsv' "$JSON_FILE")

if [ "$errors" -gt 0 ]; then
  exit 1
fi

count=$(jq '.exercises | length' "$JSON_FILE")
echo "All $count exercise IDs are unique and all types are valid. Validation passed."
