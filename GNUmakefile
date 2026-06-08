APP_NAME = WordProcessor
BUILD_DIR = build
MACOS_APP = $(BUILD_DIR)/$(APP_NAME).app
MACOS_EXE = $(MACOS_APP)/Contents/MacOS/$(APP_NAME)
OBJC_FILES = Sources/main.m Sources/WPAppDelegate.m Sources/WPDocument.m

ifeq ($(GNUSTEP_MAKEFILES),)

.PHONY: all gnustep macos clean

all: macos

gnustep:
	@echo "GNUSTEP_MAKEFILES is not set. Source your GNUstep make environment first."
	@exit 1

macos: $(MACOS_EXE)

$(MACOS_EXE): $(OBJC_FILES) Resources/Info.plist
	mkdir -p "$(MACOS_APP)/Contents/MacOS" "$(MACOS_APP)/Contents/Resources"
	cp Resources/Info.plist "$(MACOS_APP)/Contents/Info.plist"
	clang -Wall -Wextra -fobjc-exceptions -fconstant-string-class=NSConstantString -framework Cocoa $(OBJC_FILES) -o "$(MACOS_EXE)"

clean:
	rm -rf "$(BUILD_DIR)"

else

include $(GNUSTEP_MAKEFILES)/common.make

WordProcessor_OBJC_FILES = \
	Sources/main.m \
	Sources/WPAppDelegate.m \
	Sources/WPDocument.m

WordProcessor_APPLICATION_ICON =
WordProcessor_MAIN_MODEL_FILE =

ADDITIONAL_OBJCFLAGS += -Wall -Wextra

include $(GNUSTEP_MAKEFILES)/application.make

.PHONY: gnustep macos

gnustep: all

macos: $(MACOS_EXE)

$(MACOS_EXE): $(OBJC_FILES) Resources/Info.plist
	mkdir -p "$(MACOS_APP)/Contents/MacOS" "$(MACOS_APP)/Contents/Resources"
	cp Resources/Info.plist "$(MACOS_APP)/Contents/Info.plist"
	clang -Wall -Wextra -fobjc-exceptions -fconstant-string-class=NSConstantString -framework Cocoa $(OBJC_FILES) -o "$(MACOS_EXE)"

endif
