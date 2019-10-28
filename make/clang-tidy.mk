#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: modernize C/C++ source code
#%DEP:|extra/clang|
#%


.PHONY: tidy-list
tidy-list:
	clang-tidy --list-checks -checks='*'


# BUG: error: no such file or directory: '@/path/to/_build-clang-Debug/qa_cxx_warn.flags' [clang-diagnostic-error]
#   => must ignore this cmdline argument somehow or train clang-tidy to read such cmdarg-files
.PHONY: tidy
tidy:
	find '$(abspath $(d_pj))' -xtype d -name '_*' -prune -o \
	  -regextype egrep -regex '.*\.(cpp|hpp|cc|cxx)' -exec \
		clang-tidy -p='$(bdir)' $(_args) {} +



.PHONY: tidy-fix
tidy-fix: _args := --warnings-as-errors --fix --fix-errors
tidy-fix: tidy



.PHONY: tidy-prof
tidy-prof: _args := --enable-check-profile
tidy-prof: tidy
