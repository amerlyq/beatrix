#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: text spelling errors for docs and comments -- detect and suggest variants
#%REF: http://aspell.net/man-html/index.html
#%TUT: https://lists.gnu.org/archive/html/aspell-user/2011-09/msg00012.html
#%DEP:|extra/aspell|aspell-{en,ru,uk}|
#%
$(call &AssertVars,btrx)


#%ALIAS
.PHONY: as af asa asf
as: aspell-index
af: aspell-index-fix
asa: aspell-all
asf: aspell-all-fix


.PHONY: aspell-index
aspell-index: | $(btrx)spell/
	@aspell-multi index '$|' list '*.rst'


.PHONY: aspell-index-fix
aspell-index-fix: | $(btrx)spell/
	@aspell-multi index '$|' check '*.rst'


.PHONY: aspell-all
aspell-all: | $(btrx)spell/
	@aspell-multi all '$|' list '*.rst'


.PHONY: aspell-all-fix
aspell-all-fix: | $(btrx)spell/
	@aspell-multi all '$|' check '*.rst'
