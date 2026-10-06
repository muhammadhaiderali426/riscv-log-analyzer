# RISC-V Log Analyzer

A shell-based tool for analyzing RISC-V simulation log files. It parses test results, calculates pass/fail statistics, and generates summary reports in text or CSV format.

## Features

- Parses simulation logs for PASS, FAIL, and SKIP test results
- Calculates pass rate and timing statistics (min/max/avg execution time)
- Lists all failing tests by name
- Supports text and CSV output formats
- Can save reports to a file or print to the terminal
- Verbose mode for diagnostic output

## Installation

Clone the repository and make the scripts executable:

git clone git@github.com:muhammadhaiderali426/riscv-log-analyzer.git
cd riscv-log-analyzer
chmod +x scripts/*.sh

Check that required tools are installed:

make setup

## Usage

### Basic usage

./scripts/analyze.sh test_data/sample_sim.log

### With options

./scripts/analyze.sh test_data/sample_sim.log --format csv --output output/report.csv --verbose

### Using the Makefile

make all      # Run analyzer on all log files in test_data/
make test     # Run tests and verify results
make report   # Generate reports for all log files in output/
make clean    # Remove generated output files
make setup    # Check required tools are installed
make help     # Show available targets

## Sample Output

=== RISC-V Simulation Log Analysis ===
Log file: test_data/sample_fail.log

--- Results Summary ---
Total tests: 5
Passed:      3 (60.0%)
Failed:      2 (40.0%)
Skipped:     0 (0.0%)

--- Failed Tests ---
  1. rv32i-sll
  2. rv32i-beq

--- Timing Statistics ---
Min time:  0.42s
Max time:  2.31s
Avg time:  1.08s

--- Verdict: FAIL ---

## Project Structure

riscv-log-analyzer/
├── README.md
├── Makefile
├── .gitignore
├── scripts/
│   ├── analyze.sh
│   ├── setup_env.sh
│   └── generate_report.sh
├── test_data/
│   ├── sample_sim.log
│   ├── sample_pass.log
│   └── sample_fail.log
├── output/
└── docs/
    └── USAGE.md

## Author

Muhammad Haider Ali — MEDS Module 1 Grand Assignment
