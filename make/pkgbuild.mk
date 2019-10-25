#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: build ArchLinux packages
#%DEPS:|core/makepkg|
#%NEED: file "PKGBUILD"
#%
$(call &AssertVars,bdir btrx pkgname)

_pkgs := pkg-beatrix pkg-$(pkgname)
&dpkg = $(abspath $|/$(dir $<))

#%ALIAS (incremental aggregation)
.PHONY: pkgs
pkgs: $(_pkgs)


.PHONY: pkg-beatrix
pkg-beatrix: _args := --asdeps
pkg-beatrix: beatrix/PKGBUILD


.PHONY: pkg-$(pkgname)
pkg-$(pkgname): PKGBUILD


#%USE: $ makepkg [ENVVAR=...]
# ALT(--force): --needed | $(if $(INTERACTIVE),,--noconfirm) | export BUILDDIR := $(bdir)
# THINK: using '-C' for clean builds (re-dld all src)
$(_pkgs): | $(bdir)/
	install -vCDm644 -t '$(&dpkg)' '$<'
	>/dev/tty env -C '$(&dpkg)' -- makepkg --syncdeps --clean --install $(if $(force),--force) $(_args)
