#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: generate documentation
#%
$(call &AssertVars,bdir &here)

## FIXED: sphinx inline code
# https://stackoverflow.com/questions/21591107/sphinx-inline-code-highlight
# /same/dir/as/conf.py/docutils.conf
#   [restructuredtext parser]
#   syntax_highlight = short


.PHONY: doxy
#%ALIAS: [doc]
doxy: doxygen



.PHONY: doxygen
doxygen: | $(bdir)/_doxy/
	'$(&here)gen-clean' . '$|' '$(&version)'



# BAD:CMP: dep "$(.doxy)" is unnecessary for .PHONY and makes readability really bad
# .doxy := $(&here)gen-clean
# .PHONY: doxygen
# doxygen: $(.doxy) | $(bdir)/_doxy/
# 	'$<' . '$|' '$(&version)'
