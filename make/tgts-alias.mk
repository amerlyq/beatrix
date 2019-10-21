#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: preconfigured targets for cmdline batch processing (OR parallel in recursive make)
#%

.PHONY: b c gv r t x
b: build
c: config
gv: graphviz
r: run
t: test
x: clean
