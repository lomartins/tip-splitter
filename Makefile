.PHONY: setup

setup:
	git init
	git config core.hooksPath .githooks
	chmod +x .githooks/pre-commit
	@echo "Git hooks configured. Run 'git add .' and commit away."
