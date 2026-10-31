CONDA_ENV_ID := myapp
CONDA_ENV_YML := environment.yml
APP_MODULE := myapp.api:app
HOST := 127.0.0.1
SERVE_PORT := 8000

include project.mk

.DEFAULT_GOAL := help

APP := $(PROJECT_ROOT)/myapp
TESTS := $(PROJECT_ROOT)/tests
DOCS := $(PROJECT_ROOT)/docs
CONDA_PYTHON = $$(conda run -n $(CONDA_ENV_ID) which python)
CLEAN := $(PROJECT_ROOT)/.pytest_cache \
         $(PROJECT_ROOT)/build \
         $(PROJECT_ROOT)/dist \
         $(PROJECT_ROOT)/*.egg-info \
         $(PROJECT_ROOT)/.coverage \
         $(PROJECT_ROOT)/coverage.xml
DEEP_CLEAN := $(PROJECT_ROOT)/.log $(DOCS)/_build

.PHONY: all build run docs test format environment clean deep-clean help

build: environment test docs

all: build run

run:
	@$(CONDA_PYTHON) -m uvicorn $(APP_MODULE) --host $(HOST) --port $(SERVE_PORT) --reload

docs: $(LOG_FILE)
	@$(MAKE) --no-print-directory -C $(DOCS) html || exit 1

test:
	@$(CONDA_PYTHON) -m pytest --cov=myapp --cov-branch --cov-report=xml

format:
	@$(CONDA_PYTHON) -m ruff format .
	@npx --yes prettier --write "myapp/static/*.js" "myapp/static/*.css"

environment: $(CONDA_ENV_YML) $(LOG_FILE)
	@if ! conda info --envs | awk '{print $$1}' | grep -qx "$(CONDA_ENV_ID)"; then \
		conda env create -n "$(CONDA_ENV_ID)" -f "$(CONDA_ENV_YML)" $(LOGGER); \
	fi

clean:
	@echo "    --------------------------------------------------"
	@echo "    Cleaning ..."
	@echo "    --------------------------------------------------"
	@$(call SAFE_RM_LIST,$(CLEAN))
	@find $(APP) $(TESTS) -name "__pycache__" -exec echo " xx {}" \; -exec rm -rf {} +
	@find $(APP) $(TESTS) -name "*.pyc" -exec echo " xx {}" \; -delete
	@$(MAKE) --no-print-directory -C $(DOCS) clean || true
	@find . -name ".DS_Store" -type f -delete

deep-clean: clean
	@echo "    --------------------------------------------------"
	@echo "    Deep cleaning ..."
	@echo "    --------------------------------------------------"
	@$(call SAFE_RM_LIST,$(DEEP_CLEAN))

$(LOG_FILE):
	@mkdir -p $(dir $(LOG_FILE))
	@touch $(LOG_FILE)

help:
	@echo "    --------------------------------------------------"
	@echo "    Available targets:"
	@echo "    --------------------------------------------------"
	@echo "    build        Build myapp from scratch (environment + test + docs)"
	@echo "    all          Build then run the app locally"
	@echo "    run          Run myapp app locally"
	@echo "    docs         Build documentation"
	@echo "    test         Run unit tests"
	@echo "    format       Format code to 150 columns (ruff + prettier)"
	@echo "    environment  Create Conda environment"
	@echo "    clean        Cleanup unnecessary files and directories (safe)"
	@echo "    deep-clean   Deep clean generated files and logs (use with caution!)"
	@echo "    help         Show this help message"
