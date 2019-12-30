#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: beatrix test-only main Makefile
.DEFAULT_GOAL = none
pkgname := beatrix-t
pkgabbr := bx-t

include pj-begin.mk
include pj-vars.mk

brun := testsuite

include pj-tgts.mk
include pj-end.mk
