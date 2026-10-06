#!/bin/bash
set -euo pipefail

# Script: generates analysis reports for all log files in test_data/

SCRIPT_DIR="$(dirname "$0")"
ANALYZE_SCRIPT="$SCRIPT_DIR/analyze.sh"
TEST_DATA_DIR="test_data"
OUTPUT_DIR="output"

mkdir -p "$OUTPUT_DIR"

echo "Generating reports for all log files..."

for log_file in "$TEST_DATA_DIR"/*.log; do
    [ -f "$log_file" ] || continue

    base_name=$(basename "$log_file" .log)
    report_path="$OUTPUT_DIR/${base_name}_report.txt"

    echo "Processing: $log_file -> $report_path"
    "$ANALYZE_SCRIPT" "$log_file" --output "$report_path" || true
done

echo "All reports generated in $OUTPUT_DIR/"
