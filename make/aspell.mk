#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: text spelling errors for docs and comments -- detect and suggest variants
#%REF: http://aspell.net/man-html/index.html
#%TUT: https://lists.gnu.org/archive/html/aspell-user/2011-09/msg00012.html
#%DEP:|extra/aspell|aspell-{en,ru,uk}|
#%ALT:(sphinx+enchant): https://superuser.com/questions/287088/spell-checking-restructuredtext
#%
$(call &AssertVars,btrx d_pj)


.PHONY: as af asa asf
#%ALIAS: [aspell]       #[check text spelling]
as: aspell-index        # check only files added to "git index"
af: aspell-index-fix    # fix files from "git index" in TUI and add corrections to "beatrix" dicts
aS: aspell-all          # check all files in project indiscriminately
aF: aspell-all-fix      # fix spelling in all files (private words must be manually added to project private dict)


BEATRIX_ASPELL_PRIVATE := $(d_pj)/beatrix-private/aspell.en.pws
ifneq (,$(wildcard $(BEATRIX_ASPELL_PRIVATE)))
export BEATRIX_ASPELL_PRIVATE
endif


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
