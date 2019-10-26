#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: makefile reflections for embedded help
#%USAGE: must be included as far as possible -- to enumerate all included '*.mk' files
#%
$(call &AssertVars,root &VIEW)

#%ALIAS
.PHONY: h
h: list-targets


_tgts := $(shell sed -rn 's/^([a-z][-a-z0-9.]*):(\s.*|$$)/\1/p' $(MAKEFILE_LIST) | sort -u)
# _phony:= $(shell sed -rn '/^\.PHONY: (.*)/{s//\1/;s/\s+/\n/g;p}' '$(MAKEFILE_LIST)'|sort -u)
# ifeq ($(ALLPHONY),1)
# _tgts := $(filter-out all help,$(_tgts))
# else
# _tgts := $(filter-out $(_phony),$(_tgts))
# endif


# HACK: always install hooks when doing any (allowed) action in make
_always_run := hooks-install
_mixin := $(filter $(_always_run),$(_tgts))
ifneq (,$(_mixin))
$(filter-out $(_mixin),$(_tgts)): $(_mixin)
endif



# ALT:DEBUG:(Ninja): $ ninja -t targets all
# TODO:(help-list): annotate each line by comment "#%SUM:" directly over recipe
# OR: @:$(foreach t,$(_tgts),$(info $t))
.PHONY: list-targets
list-targets:
	@printf '%s\n' $(_tgts) | column -c '$(shell tput cols)'



# OR: find -name '*.mk' -print0 | xargs -0 awk ...
.PHONY: list-aliases
list-aliases: _args := $(MAKEFILE_LIST)
list-aliases:
	awk '/^#%ALIAS/,/^\s*$$/{if(/^[a-z][-a-z0-9.]*:/)print}' $(MAKEFILE_LIST)



.PHONY: help-debug
help-debug:
	+$(MAKE) --print-data-base | $(&VIEW)



.PHONY: help help-all
help-all: _args := $(MAKEFILE_LIST)
help help-all:
	@sed -rn '/^(.*\s)?#%/s///p' $(or $(_args),$(root))
