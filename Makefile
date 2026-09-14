.PHONY: all opencode remove

all: opencode

opencode:
ifeq ($(OS),Windows_NT)
	powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Target opencode
else
	sh install.sh opencode
endif

remove:
ifeq ($(OS),Windows_NT)
	powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Target remove
else
	sh install.sh remove
endif
