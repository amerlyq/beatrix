#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: generate tag files for Vim/etc
#%DEPS:|extra/ctags|
#%


.PHONY: tags
tags:
	tags-gen-cpp . > tags



.PHONY: tags-all
tags-all:
	ctags -R



# MOVE:SEP: file of same name
# FIXME:
.PHONY: cscope
cscope:
	cscope -qbek
