#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: check project to be compliant with REUSE v3.0+ Specification and SPDX v2.1+ annotations
#%USAGE:REF: https://reuse.readthedocs.io/en/stable/usage.html
#%DEP:|aur/reuse|
#%HACK:|moreutils/chronic|: suppress output unless got error
#%
#
# INFO: fsfe-reuse always treats submodules as inseparable part of single SPDX Project/Package
#   => impossible to pass REUSEv3.0 for both cases of cloned submodules and main repo only (RQ: different license lists)
#     i.e. if submodules aren't initialized/cloned -- whole your repo is dysfunctional
#   HACK:MAYBE: use symlinks to submodule-only licenses FAIL: dangling symlinks are still detected
#   ALT:SEE:REQ:(--recursive): allow separate license list for submodules and main repo
#     https://github.com/fsfe/reuse-docs/issues/36
#     https://github.com/fsfe/reuse-tool/issues/29
#

#%ALIAS
.PHONY: reuse
reuse: reuse-all    # fsfe-reuse tool to check SPDX annotations compliance


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
