#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: frequent generic targets for all projects
#%
$(call &AssertVars,bdir version)

_bdir := $(bdir)


.PHONY: clean
clean:
	if test -d '$(_bdir)'; then find -H '$(_bdir)' -mindepth 1 -maxdepth 1 \
	  -xtype d -name '_*' -prune -o -exec rm -rf {} +; fi



.PHONY: distclean
distclean:
	rm -rf --preserve-root '$(_bdir)/'



.PHONY: doxygen
doxygen: | $(_bdir)/_doxy/
	doxygen-clean . '$|' '$(version)'
