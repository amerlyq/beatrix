#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: frontend to buildroot
#%HELP: $ m br-help br-list-defconfigs br-ccache-stats
#%PERF: new-cold=30min ccache-warm=10min
#%
$(call &AssertVars,d_pj bdir &here)

br2tag := otbs/buildroot/release
br2tgz := buildroot-2020.02.tar.gz
br2ext := $(&here)ext

br2dfl := qemu-arm
br2cfg := $(or $(BTRX_BR2_CONFIG),$(br2dfl),default)
br2set := $(br2ext)/board/$(br2cfg)


# THINK: move into separate out-of-src.mk file
Opfx  := $(or $(BTRX_O_PREFIX),_build)
Oifx  := $(or $(BTRX_O_INFIX),-)
Osfx  := $(or $(BTRX_O_SUFFIX),$(br2cfg),$(error))
Odir  := $(or $(BTRX_O_DIR),$(Opfx)$(Oifx)$(Osfx))
# Oroot := $(or $(BTRX_O_ROOT),$(BTRX_O_TMP),/tmp/beatrix)
Oroot := $(or $(BTRX_O_ROOT),$(Ocache),$(d_pj),$(error),.)
Opath := $(or $(BTRX_O_PATH),$(Oroot)/$(Odir))
override O := $(or $(O),$(Opath))

# br2src := $(d_pj)/_src-buildroot
br2src := $(Ocache)/$(if $(filter $(d_pj)%,$(Ocache)/),_src-)buildroot

# NOTE: populate kernel images vars for qemu and gdb
include $(br2set)/gen.mk

.PHONY: br brc
#%ALIAS: [buildroot]        #[buildroot]
br: buildroot-all           # generate
brc: buildroot-reconfigure  # reconfigure
br-%: buildroot-% ;         # passthrough


$(br2src)/Makefile: | $(br2src)/
	git -C '$(btrx)' cat-file -p '$(br2tag):$(br2tgz)' \
	| tar -C '$(br2src)' -xzf- --strip-components=1
	chmod --recursive a-w -- '$(br2src)'


# BAD: don't update if timestamp
#   FIND: how I did it earlier
# buildroot-reconfigure: $(O)/.config
# FUTURE:DEV: merge cfg fragments or supply them as overlay
# FAIL:(buildroot-btrx_$(br2cfg)_defconfig): unexpected when running $ menu savedefconfig
#   !! overwrites symlink in configs/ by actual file
#   BAD:ALSO: must create symlinks to appropriate configs licenses
.PHONY: buildroot-reconfigure
buildroot-reconfigure: buildroot-btrx_$(br2cfg)_defconfig

## ALT:HACK: allow local-only root defconfig to override btrx one
# vpath defconfig $(BTRX_BR2_SET_DIR)
# vpath *.config  $(BTRX_BR2_SET_DIR)
# $(O)/.config: defconfig
# $(O)/.config: $(br2set)/defconfig $(br2src)/Makefile
# $(O)/.config: override br2args += BR2_DEFCONFIG='$(abspath $<)'
# $(O)/.config: buildroot-defconfig

## Tweaks
# override: @args += ROOTFS_SQUASHFS_ARGS='[-noappend -processors $$(PARALLEL_JOBS)] -all-root -b 256K -nopad'
# export XZ_OPT := --verbose -9 --threads=0 --check=crc32


.PHONY: buildroot-ccache-stats
buildroot-ccache-stats: export CCACHE_OPTIONS = --show-stats
buildroot-ccache-stats: buildroot-ccache-options


.PHONY: buildroot-ccache-reset
buildroot-ccache-reset: export CCACHE_OPTIONS = --zero-stats
buildroot-ccache-reset: buildroot-ccache-options


.PHONY: buildroot-%
buildroot-%: export MAKEFLAGS :=
# INFO: BR2_EXTERNAL is :-list of paths relative to br2src (rightmost overrides others)
buildroot-%: export BR2_EXTERNAL := $(abspath $(br2ext))
# RENAME? BTRX_TOPDIR BTRX_PJ_DIR BTRX_TOPPJ_DIR BTRX_ROOT_DIR BTRX_ROOT_PATH
# buildroot-%: export BTRX_TOP_DIR := $(abspath $(d_pj))
# buildroot-%: export BTRX_DIR := $(abspath $(btrx))
buildroot-%: export BTRX_CACHE_PREFIX := $(abspath $(Ocache))/$(if $(filter $(d_pj)%,$(Ocache)/),_)
buildroot-%: export BTRX_BR2_SET_DIR := $(abspath $(br2set))
buildroot-%: $(br2src)/Makefile # $(O)/.config
	+$(MAKE) -C '$(br2src)' -- O='$(abspath $(O))' '$*' $(br2args)
