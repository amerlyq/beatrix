#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: makefile reflections for embedded help
#%USAGE: must be included as far as possible -- to enumerate all included '*.mk' files
#%
$(call &AssertVars,root &VIEW)

.PHONY: h ha hc hl
#%ALIAS: [help]         #[help and introspection]
h: help                 # shortcut to call default composite help
ha: list-aliases        # short aliases to long commands with comments
hc: list-commands-paged # list all commands in multiple columns
hl: list-commands       # list all commands in single sorted column


_tgts := $(shell sed -rn 's/^([a-z][-a-z0-9.]*):(\s.*|$$)/\1/p' $(MAKEFILE_LIST) | sort -u)
# _phony:= $(shell sed -rn '/^\.PHONY: (.*)/{s//\1/;s/\s+/\n/g;p}' '$(MAKEFILE_LIST)'|sort -u)
# ifeq ($(ALLPHONY),1)
# _tgts := $(filter-out all help,$(_tgts))
# else
# _tgts := $(filter-out $(_phony),$(_tgts))
# endif


# DEV:(args.mk): "make help ai" => grep annotation from "make list-aliases"
# TODO:(help-list): annotate each line by comment "#%SUM:" directly over recipe
#%SUM: "help" is actually short summary with long annotated list of commands aliases
.PHONY: help
help: help-main list-aliases



.PHONY: list-commands
list-commands:
	@:$(foreach t,$(_tgts),$(info $t))



.PHONY: list-commands-paged
list-commands-paged:
	@printf '%s\n' $(_tgts) | column -c '$(shell tput cols)'



# MAYBE:DEV: use file basename instead of ALIAS comment :: "package.mk" -> "[package]"
# OR: find -name '*.mk' -print0 | xargs -0 awk ...
# OLD: print only aliases :: if(/^[a-z][-a-z0-9.]*:[^=]+(#|$$)/)
.PHONY: list-aliases
list-aliases: _args := $(MAKEFILE_LIST)
list-aliases:
	@awk '/^#%ALIAS/,/^\s*$$/{ \
	  if(/^#%ALIAS/){sub(/\S+\s*/,"");printf("\n%s\n",$$0)} \
	  else if(length($$0)){print"  "$$0} \
	}' $(MAKEFILE_LIST) | column -Lt -s'#' -o' |'



.PHONY: help-debug
help-debug:
	+$(MAKE) --print-data-base | $(&VIEW)



.PHONY: help-main help-all
help-all: _args := $(MAKEFILE_LIST)
help-main help-all:
	@sed -rn '/^(.*\s)?#%/s///p' $(or $(_args),$(root))
