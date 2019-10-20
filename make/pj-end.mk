#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: boilerplate
#%USAGE: include at the very bottom of the project root Makefile after everything else
#%
# $(call &AssertVars,_tgts-hide)

_tgts := $(shell sed -rn 's/^([a-z][-a-z0-9.]*):(\s.*|$$)/\1/p' $(MAKEFILE_LIST) | sort -u)
# _phony:= $(shell sed -rn '/^\.PHONY: (.*)/{s//\1/;s/\s+/\n/g;p}' '$(MAKEFILE_LIST)'|sort -u)
# ifeq ($(ALLPHONY),1)
# _tgts := $(filter-out all help,$(_tgts))
# else
# _tgts := $(filter-out $(_phony),$(_tgts))
# endif


# NOTE: skip rebuilding of all included files
$(MAKEFILE_LIST):: ;


# -L 1 -P "${nameprefix}*" | tail -n +2
.PHONY: tree
tree: export LC_ALL=C
tree:
	tree --noreport -aAC --prune --matchdirs --dirsfirst -I '_*|.*' -- .


# TODO:(help-list): annotate each line by comment "#%SUM:" directly over recipe
# OR: @:$(foreach t,$(_tgts),$(info $t))
.PHONY: list
list:
	@printf '%s\n' $(_tgts) | column -c '$(shell tput cols)'


.PHONY: help help-all
help-all: _args := $(MAKEFILE_LIST)
help help-all:
	@sed -rn '/^(.*\s)?#%/s///p' $(or $(_args),$(root))
