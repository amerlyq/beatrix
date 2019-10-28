#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: text spelling errors for docs and comments -- detect and suggest variants
#%REF: http://aspell.net/man-html/index.html
#%DEP:|extra/aspell|aspell-{en,ru,uk}|
#%
$(call &AssertVars,btrx)


#%ALIAS
.PHONY: af
af: aspell-fix


.PHONY: aspell
aspell: | $(btrx)spell/
	@aspell-multi '$|' list '*.rst'



.PHONY: aspell-fix
aspell-fix: | $(btrx)spell/
	@aspell-multi '$|' check '*.rst'
