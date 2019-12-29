#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: generate documentation
#%
$(call &AssertVars,bdir)

## FIXED: sphinx inline code
# https://stackoverflow.com/questions/21591107/sphinx-inline-code-highlight
# /same/dir/as/conf.py/docutils.conf
#   [restructuredtext parser]
#   syntax_highlight = short

.PHONY: doxygen
doxygen: | $(bdir)/_doxy/
	doxygen-clean . '$|' '$(version)'
