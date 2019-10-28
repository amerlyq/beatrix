#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: build ArchLinux packages
#%DEPS:|core/makepkg|
#%NEED: file "PKGBUILD"
#%
$(call &AssertVars,bdir pkgname)


#%ALIAS (incremental aggregation)
.PHONY: pkg pkgs
pkg: pkg-$(pkgname)


.PHONY: pkg-beatrix
pkgs: pkg-beatrix
pkg-beatrix: _args := --asdeps
pkg-beatrix: beatrix/PKGBUILD


.PHONY: pkg-$(pkgname)
pkgs: pkg-$(pkgname)
pkg-$(pkgname): PKGBUILD


#%USE: $ makepkg [ENVVAR=...]
# ALT(--force): --needed | $(if $(INTERACTIVE),,--noconfirm) | export BUILDDIR := $(bdir)
# THINK: using '-C' for clean builds (re-dld all src)
&dpkg = $(abspath $(bdir)/_pkg/$(dir $<))
pkg-beatrix \
pkg-$(pkgname):
	install -vCDm644 -t '$(&dpkg)' '$<'
	env -C '$(&dpkg)' -- makepkg --syncdeps --clean --install $(if $(force),--force) $(_args) >/dev/tty
