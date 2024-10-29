# Environment setup
ENV_FILE := /opt/ees/env.sh
SHELL := /bin/bash

# Directory structure
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
SIM_DIR := sim

# GHDL configuration with environment sourcing
GHDL := source $(ENV_FILE) && ghdl
GHDL_FLAGS := --workdir=$(OBJ_DIR)
GHDL_ANALYZE := $(GHDL) -a $(GHDL_FLAGS)
GHDL_ELABORATE := $(GHDL) -e $(GHDL_FLAGS)
GHDL_RUN := $(GHDL) -r $(GHDL_FLAGS)

# Specify files in dependency order
VHDL_SOURCES := \
	$(SRC_DIR)/xorN.vhdl \
	$(SRC_DIR)/xorN_tb.vhdl

# Default top-level entity for testbench
TESTBENCH := xor_N_tb
TESTBENCH_ARCH := testbench1


# Default target
all: check_env dirs analyze elaborate

# Check if environment file exists
check_env:
	@test -f $(ENV_FILE) || (echo "Error: Environment file $(ENV_FILE) not found" && exit 1)
	@echo "Using environment from $(ENV_FILE)"

# Create directory structure
dirs:
	@mkdir -p $(SRC_DIR)
	@mkdir -p $(OBJ_DIR)
	@mkdir -p $(BIN_DIR)
	@mkdir -p $(SIM_DIR)

# Show debug info
debug:
	@echo "VHDL files (in order):"
	@for f in $(VHDL_SOURCES); do echo "  $$f"; done
	@echo "Source directory contents:"
	@ls -la $(SRC_DIR)

# Analyze VHDL files
analyze: dirs
	@echo "Analyzing files in order:"
	@for f in $(VHDL_SOURCES); do \
		echo "  $$f"; \
		$(GHDL_ANALYZE) "$$f" || exit 1; \
	done

# Elaborate the testbench
elaborate: analyze
	$(GHDL_ELABORATE) -o $(BIN_DIR)/$(TESTBENCH) $(TESTBENCH) $(TESTBENCH_ARCH)
	$(BIN_DIR)/$(TESTBENCH) --wave=$(SIM_DIR)/wave.ghw

# Run the simulation
run: elaborate
	@echo "Opening waveform viewer..."
	gtkwave $(SIM_DIR)/wave.ghw

# Clean generated files
clean:
	rm -rf $(OBJ_DIR)
	rm -rf $(BIN_DIR)
	rm -rf $(SIM_DIR)

# Clean and create fresh directories
reset: clean dirs

# Help target
help:
	@echo "Available targets:"
	@echo "  make all        - Create directories and compile project"
	@echo "  make dirs       - Create directory structure"
	@echo "  make analyze    - Analyze VHDL files"
	@echo "  make elaborate  - Elaborate the testbench"
	@echo "  make run        - Run the simulation"
	@echo "  make clean      - Remove generated files"
	@echo "  make reset      - Clean and recreate directories"
	@echo "  make debug      - Show debug information"
	@echo "  make help       - Show this help message"

.PHONY: all check_env dirs debug analyze elaborate run clean reset help