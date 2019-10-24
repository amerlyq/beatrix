#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: common functions and environment
#%
$(call &AssertVars,btrx EDITOR)

### --- Environment ---
export PATH := $(btrx)bin:$(PATH)


### --- Functions ---
# &HasProg = $(shell command -v '$(1)' 2>/dev/null)
# &CheckProgs = $(foreach x,$(1),$(if $(call &HasProg,$x),,$(error This project requires program '$v')))

&VIEW = $(EDITOR) - -c 'setl noro ma bt=nofile nowrap'



### --- Targets ---
.PRECIOUS: %/
%/: ; +@mkdir -p '$@'


.PHONY: all
all:
