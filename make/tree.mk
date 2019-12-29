#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: show file structure
#%DEPS:|extra/tree|
#%

.PHONY: hb
#%ALIAS: [filesystem]
hb: tree-build-dirs     # list all build dirs


# THINK: also filter-out "beatrix" folder to show only user's files
#   <= BUT: unneeded if "beatrix" becomes standalone app instead of embedding into pj
.PHONY: tree
tree: export LC_ALL=C
tree:
	tree --noreport -aAC --prune --matchdirs --dirsfirst \
	  -I '_*|.*' -- . | sed -rz 's/\n?$$/\n/'


# MAYBE: ... | tail -n +2
.PHONY: tree-build-dirs
tree-build-dirs:
	tree --noreport -aAC --prune --matchdirs --dirsfirst \
	  -L 1 -P '_*' -- . | sed -rz 's/\n?$$/\n/'
