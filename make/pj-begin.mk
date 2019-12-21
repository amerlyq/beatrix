#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: boilerplate
#%USAGE: include at the very top of the project root Makefile before anything else
#%
.DEFAULT_GOAL ?= help
.NOTPARALLEL:
.SUFFIXES:
.PHONY: .FORCE

# BUG:(-rR): doesn't have effect on this toplevel makefile ALT:USE: multi-shebang
# MAKEFLAGS += -rR --no-print-directory

#%WARN: only shells which ends in 'sh' are simplified, otherwise interpreter is used always
SHELL := $(shell which bash)
.SHELLFLAGS := -euo pipefail -c


# BUG: no error when function misspelled $(call &AssrtVrs,here)
&AssertVars = $(foreach v,$(1),$(if $($v),,$(error This file requires non-empty var '$v')))


### --- Constants ---
# HACK:(keep trailing "/" in VAR):
#  ++ Vim 'gf' can directly open local files by ignoring path prefix
#  => USE: '$(here:/=)' to access var without trailing '/'
this := $(lastword $(MAKEFILE_LIST))
here := $(dir $(realpath $(this)))
btrx := $(dir $(here:/=))
root := $(word $(words $(MAKEFILE_LIST)),_ $(MAKEFILE_LIST))
d_pj := $(patsubst %/,%,$(dir $(root)))
