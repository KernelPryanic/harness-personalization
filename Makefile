.PHONY: install remove

install:
ifeq ($(OS),Windows_NT)
	powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Target install
else
	sh install.sh install
endif

remove:
ifeq ($(OS),Windows_NT)
	powershell -NoProfile -ExecutionPolicy Bypass -File install.ps1 -Target remove
else
	sh install.sh remove
endif
