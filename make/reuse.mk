#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: check project to be compliant with REUSE v3.0+ Specification and SPDX v2.1+ annotations
#%DEP:|aur/reuse|
#%HACK:|moreutils/chronic|: suppress output unless got error
#%

#%ALIAS
.PHONY: reuse
reuse: reuse-all


## INFO:
# * ignored $ git ls-files --ignored --exclude-standard --others
# * untracked $ git ls-files --exclude-standard --others
# * compress $ ... --directory --no-empty-directory

^reuse = $(if $(VERBOSE),,chronic )reuse lint

#%SUM:IDEA: use in commit hook (currently broken)
# BUG: generates error due to not using all licenses
.PHONY: reuse-changed
reuse-changed:
	git diff-files -z --name-only --diff-filter=d \
	  | xargs -0 $(^reuse)



#%SUM: only tracked by git (excluding deleted ones)
# BUG: reuse breaks on paths to deleted files
.PHONY: reuse-tracked
reuse-tracked:
	git ls-files -z --no-deleted \
	  | grep -z -vwF -e .reuse -e LICENSES \
	  | xargs -0 $(^reuse)



#%SUM: tracked + untracked (ignored excluded)
.PHONY: reuse-all
reuse-all:
	$(^reuse)
