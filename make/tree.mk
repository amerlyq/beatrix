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


.PHONY: tree
tree: export LC_ALL=C
tree:
	tree --noreport -aAC --prune --matchdirs --dirsfirst -I '_*|.*' -- .


# MAYBE: ... | tail -n +2
.PHONY: tree-build-dirs
tree-build-dirs:
	tree --noreport -aAC -L 1 --prune --matchdirs --dirsfirst -P '_*' -- .
