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


### --- Constants ---
this := $(lastword $(MAKEFILE_LIST))
here := $(patsubst %/,%,$(dir $(realpath $(this))))
btrx := $(patsubst %/,%,$(dir $(here)))
root := $(word $(words $(MAKEFILE_LIST)),_ $(MAKEFILE_LIST))
d_pj := $(patsubst %/,%,$(dir $(root)))


### --- Environment ---
export PATH := $(btrx)/bin:$(PATH)


### --- Functions ---
&AssertVars = $(foreach v,$(1),$(if $($v),,$(error This file requires non-empty var '$v')))
# &HasProg = $(shell command -v '$(1)' 2>/dev/null)
# &CheckProgs = $(foreach x,$(1),$(if $(call &HasProg,$x),,$(error This project requires program '$v')))


### --- Recipes ---
.PRECIOUS: %/
%/: ; +@mkdir -p '$@'


.PHONY: all
all:
