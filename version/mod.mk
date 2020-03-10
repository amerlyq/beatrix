#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: derive version from Git / CMake / "version" file
#%
$(call &AssertVars,d_pj &here)

.ver := $(&here)from-git


.PHONY: ver
#%ALIAS: [aux]
ver: version


.PHONY: version
version:
	'$(.ver)' '$(d_pj)' only


.PHONY: version-full
version-full:
	'$(.ver)' '$(d_pj)'


# NOTE: dedicated file is better than project(... <VERSION>)
#   <= because you can use it even without CMakeLists.txt
# MAYBE:BET: generate it inside build dir root (as dep of other artf) -- to not pollute the repo
.PHONY: VERSION
VERSION:
	'$(.ver)' '$(d_pj)' > '$@.tmp'
	mv -fT -- '$@.tmp' '$@'
