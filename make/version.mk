#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: derive version from Git / CMake / "version" file
#%
$(call &AssertVars,d_pj)


version = $(shell git-pj-version '$(d_pj)' $(1))


.PHONY: version
version:
	$(info $(call version,only))


.PHONY: version-full
version-full:
	$(info $(version))


.PHONY: VERSION
VERSION:
	$(file > $@,$(version))
