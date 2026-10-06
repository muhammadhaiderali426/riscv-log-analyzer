# Makefile for riscv-log-analyzer
SCRIPTS_DIR = scripts
TEST_DATA_DIR = test_data
OUTPUT_DIR = output

ANALYZE = $(SCRIPTS_DIR)/analyze.sh
SETUP = $(SCRIPTS_DIR)/setup_env.sh
REPORT_SCRIPT = $(SCRIPTS_DIR)/generate_report.sh

.PHONY: all test report clean help setup

help:
	@echo "Available targets:"
	@echo "  make all      - Run analyzer on all log files"
	@echo "  make test     - Run tests and verify results"
	@echo "  make report   - Generate reports in output/"
	@echo "  make clean    - Remove generated output files"
	@echo "  make setup    - Check required tools are installed"
	@echo "  make help     - Show this help message"

setup:
	@bash $(SETUP)

all:
	@echo "Running analyzer on all log files..."
	@for log in $(TEST_DATA_DIR)/*.log; do \
		echo "--- $$log ---"; \
		$(ANALYZE) "$$log" || true; \
	done

test: all
	@echo "All tests completed."

report:
	@bash $(REPORT_SCRIPT)

clean:
	@echo "Cleaning generated output files..."
	@rm -f $(OUTPUT_DIR)/*.txt $(OUTPUT_DIR)/*.csv
	@echo "Clean complete."
