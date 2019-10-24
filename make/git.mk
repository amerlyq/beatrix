#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: git hooks and other goodies
#%DEPS:|extra/git|
#%
$(call &AssertVars,btrx root)


# FIXME: replace by single batch target to run all checks
#   => then call only that target inside of hooks
.PHONY: hooks
hooks: $(btrx)hooks/pre-push
	+'$<'


^gitdir = $(shell git -C $(d_pj) rev-parse --git-dir)


## FAIL! will return different dir inside submodules
# d_git := $(^gitdir)/hooks
# .PHONY: hooks-install
# hooks-install: $(d_git)/hooks/pre-push  $(d_git)/hooks/pre-commit
# $(d_git)/hooks/% :: $(btrx)hooks/%
# 	install -Dm755 '$<' '$@'


# BAD:PERF! executes install each time
# NICE: can execute outside of git
.PHONY: hooks-install
hooks-install:
	install -vCDm755 -t '$(^gitdir)/hooks' \
	  -- '$(btrx)hooks/pre-push' '$(btrx)hooks/pre-commit'


# HACK: always install hooks on any action in make
# BUG: must depend only on known targets -- otherwise make starts accepting even unknown ones
# $(or $(MAKECMDGOALS),$(.DEFAULT_GOAL)): hooks-install
