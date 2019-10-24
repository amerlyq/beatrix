#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: generate documentation
#%
$(call &AssertVars,bdir version)


.PHONY: doxygen
doxygen: | $(bdir)/_doxy/
	doxygen-clean . '$|' '$(version)'
