#!/bin/sh
# vim:ft=make
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
:; m=$(readlink -e "$0") && exec "${d:=${m%/*}}"/bin/make-custom -C "$d" -f "$m" MAKEGUARD="$0" "$@" || exit
#
#%SUMMARY: beatrix-itself control center
#%USAGE: $ ./$0 [VERBOSE=1] [-W mytgt|-B|--always-make]
#%
ifndef MAKEGUARD
$(subst ,, ) := $(subst ,, )
this := $(lastword $(MAKEFILE_LIST))
here := $(patsubst %/,%,$(dir $(this)))
make := $(here)/bin/make-custom
envp := (let () (setenv "MAKEGUARD" "$(this)") (setenv "MAKEFLAGS" "$(MAKEFLAGS)") (environ))
args := $(subst \|,$( ),$(patsubst %,"%",$(subst \$( ),\|,$(MAKECMDGOALS) $(MAKEOVERRIDES))))
$(guile (execle "$(make)" $(envp) "$(make)" "--file=$(this)" $(args)))
else
unexport MAKEGUARD
.DEFAULT_GOAL = check-all
# BUG:NEED: "-ctl" otherwise collisions with "pkg-install"
pkgname := beatrix-ctl
pkgabbr := bx

include pj-begin.mk
$(call &AssertVars,here)

include pj-vars.mk

#%DEBUG: $(error $(.INCLUDE_DIRS))
brun := testsuite

include pj-tgts.mk
include pj-end.mk
endif
