.PHONY: all claude opencode

all: claude opencode

claude:
ifeq ($(OS),Windows_NT)
	powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Target claude
else
	sh install.sh claude
endif

opencode:
ifeq ($(OS),Windows_NT)
	powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Target opencode
else
	sh install.sh opencode
endif
