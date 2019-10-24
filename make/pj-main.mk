#!/bin/sh
# vim:ft=make
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
:; exec "$(dirname "$(readlink -e "$0")")"/beatrix/bin/make-custom --file="$0" "$@"
#
#%SUMMARY: project control center
#%USAGE: $ ./$0 [VERBOSE=1] [-W mytgt|-B|--always-make]
#%HACK: create build dirs in current dir but use sources from registered repo
#%   $ cd /ram/cache && [m|/path/to/Makefile] b
#%HACK: enable zsh completion
#%   $ alias m='make' || compdef m=make && export PATH="$PWD:$PATH"
#%FIXME: rewrite whole control panel to "D-lang" srcexec file (OR: perl ?)
#%
ifndef MAKEGUARD
$(subst ,, ) := $(subst ,, )
this := $(lastword $(MAKEFILE_LIST))
here := $(patsubst %/,%,$(dir $(this)))
make := $(here)/beatrix/bin/make-custom
envp := (append (environ) (list "MAKEFLAGS=$(MAKEFLAGS)"))
args := $(subst \|,$( ),$(patsubst %,"%",$(subst \$( ),\|,$(MAKECMDGOALS) $(MAKEOVERRIDES))))
$(guile (execle "$(make)" $(envp) "$(make)" "--file=$(this)" $(args)))
else
unexport MAKEGUARD
.DEFAULT_GOAL = build
#%DEP:|airy/kirie|: for srcexec scripts per each module
# BAD: installs "kirie" alongside "coastline"
pkgname := coastline
pkgabbr := cl
# include /usr/lib/kirie.mk

include pj-begin.mk
$(call &AssertVars,here)

include pj-vars.mk

#%DEBUG: $(error $(.INCLUDE_DIRS))
brun := main

include pj-tgts.mk
include pj-end.mk
endif
