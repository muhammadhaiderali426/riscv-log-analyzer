# Usage Guide — RISC-V Log Analyzer

Detailed reference for all commands and options supported by the analyzer.

## Running the Analyzer

./scripts/analyze.sh <log_file> [options]

<log_file> is required — the path to a RISC-V simulation log to analyze.

## Options

--format [text|csv]
    Sets the output format. Default is text.
    text  : human-readable summary report
    csv   : machine-readable comma-separated values

--output <path>
    Saves the report to the given file path instead of printing to the
    terminal.

--verbose
    Prints extra diagnostic information (file being analyzed, format
    selected) before the report.

--help
    Prints the usage message and exits.

## Examples

Analyze a log and print to terminal:
./scripts/analyze.sh test_data/sample_sim.log

Analyze and save as CSV:
./scripts/analyze.sh test_data/sample_sim.log --format csv --output output/report.csv

Analyze with verbose diagnostics:
./scripts/analyze.sh test_data/sample_sim.log --verbose

## Exit Codes

0 : all tests passed
1 : one or more tests failed, or an error occurred (missing file,
    missing argument)

## Helper Scripts

scripts/setup_env.sh
    Checks that required tools (bash, grep, awk, sed, sort) are
    installed on the system.

scripts/generate_report.sh
    Batch-processes every log file in test_data/ and writes a report
    for each one into output/.

## Using the Makefile

make all      Run the analyzer on all log files in test_data/
make test     Run the analyzer on all log files and show results
make report   Generate reports for all log files into output/
make clean    Remove all generated output files
make setup    Verify required tools are installed
make help     Show available Makefile targets
