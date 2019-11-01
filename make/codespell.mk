#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: code spelling errors -- detect and suggest variants
#%REF: https://github.com/codespell-project/codespell
#%ALT: https://wiki.archlinux.org/index.php/Language_checking
#%DEP:|community/codespell|
#%

# $(call &AssertVars,VERBOSE)


#%USE: --dictionary ./style/codespell.spl --ignore-words ./style/codespell.bad
.PHONY: codespell
codespell: $(btrx)spell/codespell.ignore
	@codespell --check-filenames --check-hidden \
	  --skip='./.git,./_*' --ignore-words '$<' \
	  $(if $(VERBOSE),--summary) \
	  $(if $(INPLACE),--write-changes) \
	  $(if $(INTERACTIVE),--interactive 3)
