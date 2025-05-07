.PHONY: install test clean-logs validate prepare

# Default target
all: validate prepare install

install:
	@echo "Starting installation..."
	sudo bash scripts/install.sh

test:
	@echo "Running tests..."
	bash tests/integration/verify_installation.sh

clean-logs:
	@echo "Cleaning logs..."
	rm -rf logs/*

validate:
	@echo "Validating environment..."
	bash scripts/helpers/validate_env.sh

prepare:
	@echo "Checking dependencies..."
	bash scripts/helpers/dependencies.sh --check-only

# For development
fmt:
	find scripts/ -name "*.sh" -exec shfmt -w -i 2 -ci {} \;