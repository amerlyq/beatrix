#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: generate tag files for Vim/etc
#%DEPS:|extra/ctags|
#%
$(call &AssertVars,&here)


.PHONY: tags
#%ALIAS: [aux]
tags: ctags-cpp


.PHONY: ctags-cpp
ctags-cpp: $(&here)gen-cpp
	'$<' . > tags



.PHONY: ctags-all
ctags-all:
	ctags -R



# MOVE:SEP: file of same name
# FIXME:
.PHONY: cscope
cscope:
	cscope -qbek
