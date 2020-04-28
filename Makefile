config ?= release

COMPILE_WITH := ponyc

LIB_SRC_DIR := semver
TEST_SRC_DIR := test

LIB_SRC_FILES := $(shell find $(LIB_SRC_DIR) -name "*.pony")
TEST_SRC_FILES := $(shell find $(TEST_SRC_DIR) -name "*.pony")
SRC_FILES := $(LIB_SRC_FILES) $(TEST_SRC_FILES)

BUILD_DIR := build/$(config)
DOCS_DIR := build/docs

TEST_BINARY := $(BUILD_DIR)/test
ifeq ( ,$(WINDIR))
	TEST_BINARY_TARGET := $(TEST_BINARY)
else
	TEST_BINARY_TARGET := $(TEST_BINARY).exe
endif

ifdef config
	ifeq (,$(filter $(config),debug release))
		$(error Unknown configuration "$(config)")
	endif
endif

ifeq ($(config),release)
	PONYC = $(COMPILE_WITH)
else
	PONYC = $(COMPILE_WITH) --debug
endif

test: $(TEST_BINARY_TARGET)
	$^ --noprog

$(TEST_BINARY_TARGET): $(SRC_FILES) | $(BUILD_DIR)
	$(PONYC) -b $(TEST_BINARY) $(TEST_SRC_DIR)

clean:
	rm -rf $(BUILD_DIR)

realclean:
	rm -rf build

# FIXME: this target is currently broken
$(DOCS_DIR): $(LIB_SRC_FILES)
	rm -rf $(DOCS_DIR)
	$(PONYC) --docs-public --pass=docs --output $(DOCS_DIR) $(LIB_SRC_FILES)

docs: $(DOCS_DIR)

all: test

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

.PHONY: all clean docs realclean test
