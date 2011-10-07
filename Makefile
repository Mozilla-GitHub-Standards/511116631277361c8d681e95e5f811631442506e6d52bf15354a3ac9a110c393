APPNAME = fx-share-addon
DEPS = mixedpuppy:addon-sdk:master,github:oauthorizer:develop,github:openwebapps:release/fx-q3
PYTHON = python

ifeq ($(TOPSRCDIR),)
  export TOPSRCDIR = $(shell pwd)
endif
profile :=
ifneq ($(OWA_PROFILE),)
  profile := --profiledir="$(OWA_PROFILE)"
endif

deps  := $(TOPSRCDIR)/deps
ifneq ($(DEPSDIR),)
  deps := $(DEPSDIR)
endif

addon_sdk := $(deps)/addon-sdk/bin
oauthorizer := $(deps)/oauthorizer
openwebapps := $(deps)/openwebapps/addons/jetpack

cfx_args :=  --pkgdir=$(TOPSRCDIR) $(profile) --package-path=$(oauthorizer) --package-path=$(openwebapps) --binary-args="-console -purgecaches"

xpi_name := ffshare.xpi

test_args :=
ifneq ($(TEST),)
    test_args := -f $(TEST)
endif

# might be useful for symlink handling...
SLINK = ln -sf
ifneq ($(findstring MINGW,$(shell uname -s)),)
  SLINK = cp -r
  export NO_SYMLINK = 1
endif

all: xpi

xpi:    pull
	$(addon_sdk)/cfx xpi $(cfx_args)

pull:
	$(PYTHON) build.py $(APPNAME) $(DEPS)

test:
	$(addon_sdk)/cfx test $(cfx_args) $(test_args)

run:
	$(addon_sdk)/cfx run $(cfx_args)	

.PHONY: xpi clean pull test run
