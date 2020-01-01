#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: git hooks and other goodies
#%DEPS:|extra/git|
#%USAGE: prevent installation :: $ INSTALL_HOOKS=0 make ...
#%
$(call &AssertVars,&here)

@hooks := pre-commit pre-push

.PHONY: hkc hki hkp
#%ALIAS: [hooks]
hkc: hooks-pre-commit
hki: hooks-install
hkp: hooks-pre-push



# BET? run only installed hooks -- directly from .git dir instead of local ones
#   ALT: make choice through optional VAR
# FIXME: replace by single batch target to run all checks
#   => then call only that target inside of hooks
.PHONY: $(@hooks:%=hooks-%)
$(@hooks:%=hooks-%): hooks-% : $(&here)%
	'$<'


^gitdir = $(shell git -C $(d_pj) rev-parse --git-dir)


## FAIL! will return different dir inside submodules
# d_git := $(^gitdir)/hooks
# .PHONY: hooks-install
# hooks-install: $(d_git)/hooks/pre-push  $(d_git)/hooks/pre-commit
# $(d_git)/hooks/% :: $(&here)%
# 	install -Dm755 '$<' '$@'


# BAD:PERF! executes install each time
# NICE: can execute outside of git
.PHONY: hooks-install
hooks-install:
	install -vCDm755 -t '$(^gitdir)/hooks' -- \
	  $(@hooks:%='$(&here)%')


## HACK: always install hooks when doing any (allowed) action in make
ifneq (0,$(INSTALL_HOOKS))

# DISABLED:RQ: "commit" and "push" hooks must not interfere when you simply "download and build"
# @hook_triggers := config build
@hook_triggers :=

# BUG: must depend only on known targets -- otherwise make starts accepting even unknown ones
# $(or $(MAKECMDGOALS),$(.DEFAULT_GOAL)): $(@hook_receipts)
# ALT: @hook_receipts := $(filter $(@hook_receipts),$(_tgts))
@hook_receipts := hooks-install

ifneq (,$(@hook_receipts))
$(filter-out $(@hook_receipts),$(@hook_triggers)): $(@hook_receipts)
endif

endif
