APP_NAME := WordProcessor
BUILD_DIR := build
MACOS_APP := $(BUILD_DIR)/$(APP_NAME).app
MACOS_EXE := $(MACOS_APP)/Contents/MacOS/$(APP_NAME)
OBJC_FILES := Sources/main.m Sources/WPAppDelegate.m Sources/WPDocument.m

.PHONY: all gnustep macos clean

all:
	@if command -v gnustep-config >/dev/null 2>&1; then \
		$(MAKE) -f GNUmakefile; \
	else \
		$(MAKE) macos; \
	fi

gnustep:
	$(MAKE) -f GNUmakefile gnustep

macos: $(MACOS_EXE)

$(MACOS_EXE): $(OBJC_FILES) Resources/Info.plist
	mkdir -p "$(MACOS_APP)/Contents/MacOS" "$(MACOS_APP)/Contents/Resources"
	cp Resources/Info.plist "$(MACOS_APP)/Contents/Info.plist"
	clang -Wall -Wextra -fobjc-exceptions -fconstant-string-class=NSConstantString -framework Cocoa $(OBJC_FILES) -o "$(MACOS_EXE)"

clean:
	rm -rf "$(BUILD_DIR)"
	@if [ -n "$$GNUSTEP_MAKEFILES" ]; then $(MAKE) -f GNUmakefile clean; fi
