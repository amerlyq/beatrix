#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: targets dependent on special auxiliary programs
#%

#%DEP:|aur/reuse|
.PHONY: reuse
reuse:
	reuse lint


#%DEP:|extra/clang|
.PHONY: fmt
fmt:
	git clang-format


#%DEP:|extra/clang|
.PHONY: fmt-all
fmt-all:
	find . -xtype d -name '_*' -prune -o \
	  -regextype egrep -regex '.*\.(cpp|hpp|cc|cxx)' -exec \
	    clang-format --verbose -style=file --fallback-style=none -i {} +
