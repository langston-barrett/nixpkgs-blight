OUT := out
LOGS := $(OUT)/logs
NIX := nix
NIXFLAGS := --arg debug true
SHELL := bash

$(OUT) $(LOGS):
	mkdir -p $(OUT) $(LOGS)

$(OUT)/makefile/%: $(OUT) $(LOGS) nix/default.nix nix/do-nothing-attrs.nix nix/extract-makefile.nix
	mkdir -p $(shell dirname $@)
	nix-build $(NIXFLAGS) \
	  --attr makefile \
	  --out-link $@ \
	  --argstr name $(notdir $@) \
	  nix/default.nix |& tee $(LOGS)/$(subst /,-,$@).log

$(OUT)/cmakelists/%: $(OUT) $(LOGS) nix/default.nix nix/do-nothing-attrs.nix nix/extract-cmakelists.nix
	mkdir -p $(shell dirname $@)
	nix-build $(NIXFLAGS) \
	  --attr cmakelists \
	  --out-link $@ \
	  --argstr name $(notdir $@) \
	  nix/default.nix |& tee $(LOGS)/$(subst /,-,$@).log

$(OUT)/instrument/%: $(OUT) $(LOGS) nix/default.nix nix/lib.nix nix/do-nothing-attrs.nix nix/extract-makefile.nix nix/extract-cmakelists.nix nix/instrument.nix
	mkdir -p $(shell dirname $@)
	nix-build $(NIXFLAGS) \
	  --attr instrument \
	  --out-link $@ \
	  --argstr name $(notdir $@) \
	  nix/default.nix |& tee $(LOGS)/$(subst /,-,$@).log

$(OUT)/bitcode/%: $(OUT) $(LOGS) nix/default.nix nix/lib.nix nix/do-nothing-attrs.nix nix/extract-makefile.nix nix/extract-cmakelists.nix nix/instrument.nix nix/build-bitcode.nix
	mkdir -p $(shell dirname $@)
	nix-build $(NIXFLAGS) \
	  --out-link $@ \
	  --argstr name $(notdir $@) \
	  nix/build-bitcode.nix |& tee $(LOGS)/$(subst /,-,$@).log

$(OUT)/inject/%: $(OUT) $(LOGS) nix/default.nix nix/lib.nix nix/do-nothing-attrs.nix nix/extract-makefile.nix nix/extract-cmakelists.nix nix/instrument.nix nix/inject-flags.nix
	mkdir -p $(shell dirname $@)
	nix-build $(NIXFLAGS) \
	  --out-link $@ \
	  --argstr name $(notdir $@) \
	  nix/inject-flags.nix |& tee $(LOGS)/$(subst /,-,$@).log

.PHONY: clean
clean:
	rm -rf $(LOGS) $(OUT)
