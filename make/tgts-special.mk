#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: targets dependent on special auxiliary programs
#%
$(call &AssertVars,d_git)

#%DEPS:|extra/ctags|
.PHONY: tags
tags:
	tags-gen-cpp . > tags

.PHONY: tags-all
tags-all:
	ctags -R


#%DEP:|aur/reuse|
# TODO:DFL: ignore all unknown files -- check license only after they are added to index
# ALSO: keep current recipe and rename to "reuse-all"
.PHONY: reuse
reuse:
	reuse lint


#%DEP:|extra/clang|
.PHONY: fmt
fmt:
	git clang-format


#%DEP:|extra/clang|
.PHONY: fmt-all
fmt-all:
	find . -xtype d -name '_*' -prune -o \
	  -regextype egrep -regex '.*\.(cpp|hpp|cc|cxx)' -exec \
	    clang-format --verbose -style=file --fallback-style=none -i {} +



#%SUM: code spelling errors -- detect and suggest variants
#%REF: https://github.com/codespell-project/codespell
#%ALT: https://wiki.archlinux.org/index.php/Language_checking
#%DEP:|community/codespell|
#%USE: --dictionary ./style/codespell.spl --ignore-words ./style/codespell.bad
.PHONY: spell
spell:
	@codespell --skip='./.git,./_*' --check-filenames --check-hidden \
	  $(if $(VERBOSE),--summary) \
	  $(if $(INPLACE),--write-changes) \
	  $(if $(INTERACTIVE),--interactive 3)



#%SUM: text spelling errors for docs and comments -- detect and suggest variants
#%REF: http://aspell.net/man-html/index.html
#%DEP:|extra/aspell|aspell-{en,ru,uk}|
.PHONY: aspell
aspell: | $(btrx)/spell/
	@aspell-multi '$|' list '*.rst'

.PHONY: aspell-fix
aspell-fix: | $(btrx)/spell/
	@aspell-multi '$|' check '*.rst'



.PHONY: hooks
hooks: $(btrx)/hooks/pre-push
	+'$<'


#%DEPS:|extra/git|
ifneq (,$(d_git))
.PHONY: hooks-install
hooks-install: $(d_git)/hooks/pre-push  $(d_git)/hooks/pre-commit
$(d_git)/hooks/% :: $(btrx)/hooks/%
	install -Dm755 '$<' '$@'

# HACK: always install hooks on any action in make
$(or $(MAKECMDGOALS),$(.DEFAULT_GOAL)): hooks-install
endif
