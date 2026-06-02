# Makefile for the epa-syllabifier project

.PHONY: help venv activate ensure-venv check-uv install install-dev test test-verbose test-coverage test-properties test-matrix format lint check-whitespace clean clean-venv build ci-local all dev-setup quick-test test-file try

# Variables
VENV_DIR := .venv
PYTHON := python3
VENV_PYTHON := $(VENV_DIR)/bin/python
VENV_PIP := $(VENV_PYTHON) -m pip
UV := uv
CI_PYTHON := 3.13
SUPPORTED_PYTHONS := 3.10 3.11 3.12 3.13

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
NC := \033[0m # No Color

# Default command
help: ## Show this help
	@echo "$(GREEN)Available commands:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

venv: ## Create a virtual environment
	@echo "$(GREEN)Creating virtual environment...$(NC)"
	$(PYTHON) -m venv $(VENV_DIR)
	@echo "$(GREEN)Virtual environment created in $(VENV_DIR)$(NC)"
	@echo "$(YELLOW)To activate the virtual environment, run:$(NC)"
	@echo "  $(BLUE)source $(VENV_DIR)/bin/activate$(NC)"
	@echo "$(YELLOW)Or use:$(NC)"
	@echo "  $(BLUE)make activate$(NC)"

activate: ## Show command to activate virtual environment
	@if [ -d "$(VENV_DIR)" ]; then \
		echo "$(GREEN)To activate the virtual environment, run:$(NC)"; \
		echo "  $(BLUE)source $(VENV_DIR)/bin/activate$(NC)"; \
		echo "$(YELLOW)Or run commands in the activated environment with:$(NC)"; \
		echo "  $(BLUE)$(VENV_DIR)/bin/python your_script.py$(NC)"; \
	else \
		echo "$(YELLOW)Virtual environment not found. Create it first with:$(NC)"; \
		echo "  $(BLUE)make venv$(NC)"; \
	fi

# Target to ensure venv exists
ensure-venv:
	@if [ ! -d "$(VENV_DIR)" ]; then \
		echo "$(YELLOW)Virtual environment not found. Creating it...$(NC)"; \
		make venv; \
	fi

check-uv:
	@command -v $(UV) >/dev/null 2>&1 || { \
		echo "$(YELLOW)uv is required for the local Python test matrix. Install it from https://docs.astral.sh/uv/$(NC)"; \
		exit 1; \
	}

install: ensure-venv ## Install basic project dependencies
	@echo "$(GREEN)Installing basic dependencies...$(NC)"
	$(VENV_PIP) install -e .
	@echo "$(YELLOW)Using virtual environment: $(VENV_DIR)$(NC)"

install-dev: ensure-venv ## Install development dependencies
	@echo "$(GREEN)Installing development dependencies...$(NC)"
	$(VENV_PIP) install -e ".[dev]"
	@echo "$(YELLOW)Using virtual environment: $(VENV_DIR)$(NC)"

test: install-dev ## Run all tests
	@echo "$(GREEN)Running tests...$(NC)"
	@echo "$(BLUE)Using virtual environment: $(VENV_DIR)$(NC)"
	$(VENV_PYTHON) -m pytest tests/

test-verbose: install-dev ## Run tests with detailed output
	@echo "$(GREEN)Running tests with detailed output...$(NC)"
	@echo "$(BLUE)Using virtual environment: $(VENV_DIR)$(NC)"
	$(VENV_PYTHON) -m pytest -v tests/

test-coverage: install-dev ## Run tests with code coverage
	@echo "$(GREEN)Running tests with coverage...$(NC)"
	@echo "$(BLUE)Using virtual environment: $(VENV_DIR)$(NC)"
	$(VENV_PYTHON) -m pytest --cov=epa_syllabifier --cov-report=html --cov-report=term tests/

test-properties: install-dev ## Run exhaustive syllabifier property tests
	@echo "$(GREEN)Running exhaustive syllabifier property tests...$(NC)"
	@echo "$(BLUE)Using virtual environment: $(VENV_DIR)$(NC)"
	$(VENV_PYTHON) -m pytest -q -m properties tests/

test-matrix: check-uv ## Run tests across supported Python versions with uv
	@set -e; \
	for version in $(SUPPORTED_PYTHONS); do \
		echo "$(GREEN)Running tests with Python $$version...$(NC)"; \
		$(UV) run --python $$version --isolated --with pytest --no-project python -m pytest -q tests/; \
	done

format: check-uv ## Format code with black
	@echo "$(GREEN)Formatting code with isolated Python $(CI_PYTHON)...$(NC)"
	$(UV) run --python $(CI_PYTHON) --isolated --with black --no-project black epa_syllabifier/ tests/

lint: check-uv ## Check code format
	@echo "$(GREEN)Checking code format with isolated Python $(CI_PYTHON)...$(NC)"
	$(UV) run --python $(CI_PYTHON) --isolated --with black --no-project black --check epa_syllabifier/ tests/

check-whitespace: ## Check changed files for whitespace errors
	git diff --check
	git diff --cached --check

clean: ## Clean temporary files
	@echo "$(GREEN)Cleaning temporary files...$(NC)"
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf build/
	rm -rf dist/
	rm -rf .pytest_cache/
	rm -rf htmlcov/
	rm -rf .coverage

clean-venv: ## Remove virtual environment
	@echo "$(GREEN)Removing virtual environment...$(NC)"
	rm -rf $(VENV_DIR)

build: install-dev ## Build the package
	@echo "$(GREEN)Building package...$(NC)"
	@echo "$(BLUE)Using virtual environment: $(VENV_DIR)$(NC)"
	$(VENV_PYTHON) -m build

ci-local: clean check-uv check-whitespace ## Run the complete local CI suite
	@echo "$(GREEN)Checking code format with isolated Python $(CI_PYTHON)...$(NC)"
	$(UV) run --python $(CI_PYTHON) --isolated --with black --no-project black --check epa_syllabifier/ tests/
	@echo "$(GREEN)Running coverage with isolated Python $(CI_PYTHON)...$(NC)"
	$(UV) run --python $(CI_PYTHON) --isolated --with pytest --with pytest-cov --no-project python -m pytest --cov=epa_syllabifier --cov-report=term tests/
	$(MAKE) test-matrix
	@echo "$(GREEN)Building package with isolated Python $(CI_PYTHON)...$(NC)"
	$(UV) run --python $(CI_PYTHON) --isolated --with build --no-project python -m build

all: ci-local ## Run the complete local CI suite

# Quick development commands
dev-setup: install-dev ## Quick setup for development (create venv and install dev dependencies)
	@echo "$(GREEN)Development setup completed$(NC)"
	@echo "$(YELLOW)To activate the virtual environment, run:$(NC)"
	@echo "  $(BLUE)source $(VENV_DIR)/bin/activate$(NC)"
	@echo "$(YELLOW)Or use:$(NC)"
	@echo "  $(BLUE)make activate$(NC)"

quick-test: install-dev ## Quick test without detailed output
	$(VENV_PYTHON) -m pytest -q -m "not properties" tests/

try: ensure-venv ## Start an interactive manual syllabification session
	$(VENV_PYTHON) -c "from epa_syllabifier.cli import main; main()"

# Command to run a specific test
# Usage: make test-file FILE=test_syllabifier.py
test-file: install-dev ## Run a specific test file (use FILE=filename)
	@echo "$(GREEN)Running $(FILE)...$(NC)"
	@echo "$(BLUE)Using virtual environment: $(VENV_DIR)$(NC)"
	$(VENV_PYTHON) -m pytest tests/$(FILE) -v
