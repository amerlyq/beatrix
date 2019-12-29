#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: derive version from Git / CMake / "version" file
#%
$(call &AssertVars,d_pj &here)

.ver := $(&here)from-git

&version = $(or $(shell $(.ver) '$(d_pj)' $(1)),\
  $(error "Must have at least one symver tag for versioning to work\
  ( e.g. add tag by 'git tag 0.0.1' )"))


.PHONY: ver
#%ALIAS: [aux]
ver: version


.PHONY: version
version:
	$(info $(call &version,only))


.PHONY: version-full
version-full:
	$(info $(&version))


.PHONY: VERSION
VERSION:
	$(file > $@,$(&version))
