#!/bin/bash
set -euo pipefail
# Default values
FORMAT="text"
OUTPUT=""
VERBOSE=0
LOG_FILE=""

# Function: usage/help message dikhati hai
show_help() {
    echo "Usage: $0 <log_file> [options]"
    echo ""
    echo "Options:"
    echo "  --format [text|csv]   Output format (default: text)"
    echo "  --output <path>       Save output to file instead of stdout"
    echo "  --verbose             Enable verbose output"
    echo "  --help                Show this help message"
}
# Function: formatted report print karti hai
print_report() {
    echo "=== RISC-V Simulation Log Analysis ==="
    echo "Log file: $LOG_FILE"
    echo ""
    echo "--- Results Summary ---"
    echo "Total tests: $TOTAL"
    printf "Passed:      %d (%s%%)\n" "$PASS_COUNT" "$PASS_RATE"
    printf "Failed:      %d (%s%%)\n" "$FAIL_COUNT" "$FAIL_RATE"
    printf "Skipped:     %d (%s%%)\n" "$SKIP_COUNT" "$SKIP_RATE"
    echo ""

    if [[ "$FAIL_COUNT" -gt 0 ]]; then
        echo "--- Failed Tests ---"
        local i=1
        while IFS= read -r test_name; do
            echo "  $i. $test_name"
            i=$((i + 1))
        done <<< "$FAILING_TESTS"
        echo ""
    fi

    echo "--- Timing Statistics ---"
    echo "Min time:  ${MIN_TIME}s"
    echo "Max time:  ${MAX_TIME}s"
    echo "Avg time:  ${AVG_TIME}s"
    echo ""

    if [[ "$FAIL_COUNT" -eq 0 ]]; then
        echo "--- Verdict: PASS ---"
    else
        echo "--- Verdict: FAIL ---"
    fi
}
# Function: CSV format mein report print karti hai
print_report_csv() {
    echo "metric,value"
    echo "total_tests,$TOTAL"
    echo "passed,$PASS_COUNT"
    echo "failed,$FAIL_COUNT"
    echo "skipped,$SKIP_COUNT"
    echo "pass_rate,$PASS_RATE"
    echo "min_time,$MIN_TIME"
    echo "max_time,$MAX_TIME"
    echo "avg_time,$AVG_TIME"
}
# Function: log file se stats nikalti hai
analyze_log() {
    local log_file="$1"

    # Har status ki lines count karna
    PASS_COUNT=$(grep -c "TEST PASS:" "$log_file" || true)
    FAIL_COUNT=$(grep -c "TEST FAIL:" "$log_file" || true)
    SKIP_COUNT=$(grep -c "TEST SKIP:" "$log_file" || true)
    TOTAL=$((PASS_COUNT + FAIL_COUNT + SKIP_COUNT))
    # Pass rate nikalna (percentage)
    if [[ "$TOTAL" -gt 0 ]]; then
        PASS_RATE=$(awk "BEGIN {printf \"%.1f\", ($PASS_COUNT/$TOTAL)*100}")
        FAIL_RATE=$(awk "BEGIN {printf \"%.1f\", ($FAIL_COUNT/$TOTAL)*100}")
        SKIP_RATE=$(awk "BEGIN {printf \"%.1f\", ($SKIP_COUNT/$TOTAL)*100}")
    else
        PASS_RATE="0.0"
        FAIL_RATE="0.0"
        SKIP_RATE="0.0"
    fi

    # Failing tests ke naam nikalna
    FAILING_TESTS=$(grep "TEST FAIL:" "$log_file" | sed -E 's/.*TEST FAIL: ([a-zA-Z0-9_-]+).*/\1/' || true)
     # Saare execution times nikalna (jo bracket mein hain, jaise 0.82s)
    TIMES=$(grep -oE '\([0-9]+\.[0-9]+s\)' "$log_file" | tr -d '()s')

    # Min, Max, Avg calculate karna
    if [[ -n "$TIMES" ]]; then
        MIN_TIME=$(echo "$TIMES" | sort -n | head -1)
        MAX_TIME=$(echo "$TIMES" | sort -n | tail -1)
        AVG_TIME=$(echo "$TIMES" | awk '{sum+=$1; count++} END {printf "%.2f", sum/count}')
    else
        MIN_TIME="N/A"
        MAX_TIME="N/A"
        AVG_TIME="N/A"
    fi
}
# Arguments 
while [[ $# -gt 0 ]]; do
    case "$1" in
        --format)
            FORMAT="$2"
            shift 2
            ;;
        --output)
            OUTPUT="$2"
            shift 2
            ;;
        --verbose)
            VERBOSE=1
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            LOG_FILE="$1"
            shift
            ;;
    esac
done
# Validation: check karo log file diya gaya hai ya nahi
if [[ -z "$LOG_FILE" ]]; then
    echo "Error: No log file specified." >&2
    show_help
    exit 1
fi

# Validation: check karo file maujood hai ya nahi
if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: File '$LOG_FILE' not found." >&2
    exit 1
fi
# Analysis chalao
analyze_log "$LOG_FILE"

# Abhi ke liye simple output (baad mein improve karenge)
# Verbose mode: extra info dikhao
if [[ "$VERBOSE" -eq 1 ]]; then
    echo "[INFO] Analyzing log file: $LOG_FILE" >&2
    echo "[INFO] Output format: $FORMAT" >&2
fi

# Output: file mein ya screen par
if [[ -n "$OUTPUT" ]]; then
    if [[ "$FORMAT" == "csv" ]]; then
        print_report_csv > "$OUTPUT"
    else
        print_report > "$OUTPUT"
    fi
    echo "Report saved to: $OUTPUT"
else
    if [[ "$FORMAT" == "csv" ]]; then
        print_report_csv
    else
        print_report
    fi
fi

# Exit code decide karna
if [[ "$FAIL_COUNT" -gt 0 ]]; then
    exit 1
else
    exit 0
fi

