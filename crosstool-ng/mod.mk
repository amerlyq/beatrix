#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: frontend to crosstool-ng
#%USAGE: $ m ctng-reconfigure ctng-build
#%HELP: $ m ctng-help ctng-list-samples ctng-nconfig || m ctng-show-arm-cortexa9_neon-linux-gnueabihf
#%PERF[i7-6700HQ/SSD]:(w/o debug steps): new-cold=50min ccache-warm=XXX  (build=8.5GB + dl=250MB + install=384MB)
#%
$(call &AssertVars,d_pj bdir &here)

## BAD: release 2019-04-13 with latest linux=4.20.8
# ctng_tag := otbs/$(ctng_nm)/release
# ctng_tgz := $(ctng_nm)-1.24.0.tar.xz
# ctng_url := http://crosstool-ng.org/download/$(ctng_nm)/$(ctng_tgz)

# TODO:FUTURE: fix at certain working revision instead of latest master (and store to OTBS)
#   NEED: gcc-9.2.1 and added "archiving" PR to ct-ng
ctng_nm  := crosstool-ng
ctng_url := https://github.com/crosstool-ng/crosstool-ng/archive/master.tar.gz
ctng_ext := $(&here)ext
ctng_dl  := $(Ocache)/$(if $(filter $(d_pj)%,$(Ocache)/),_)dl
ctng_cdl :=
ctng_src := $(Ocache)/$(if $(filter $(d_pj)%,$(Ocache)/),_src-)$(ctng_nm)
ctng_exe := $(ctng_src)/ct-ng

ctng_dfl := arm-beatrix-linux-gnueabihf
ctng_cfg := $(or $(BTRX_CTNG_CONFIG),$(ctng_dfl),$(error))
ctng_set := $(ctng_ext)/samples/$(ctng_cfg)

# BAD: triple $(ctng_cfg) name is too long -- use shorter names in cfg/
# ctng_out := /data/beatrix/_build-ctng-$(ctng_cfg)
# ctng_out := $(Ocache)/_build-ctng-$(ctng_cfg)
ctng_out := /data/beatrix/_build-$(ctng_nm)
ctng_dst := $(Ocache)/x-tools
ctng_arc := $(ctng_dl)/$(ctng_nm)/$(ctng_cfg).tar.xz


.PHONY: ctng
#%ALIAS: [crosstool-ng]         #[crosstool-ng]
ctng: $(ctng_nm)-all            # generate
ctngc: $(ctng_nm)-reconfigure   # configure
ctng-%: $(ctng_nm)-% ;          # passthrough

# BAD: can't make it readonly due to build in-place $ chmod --recursive a-w -- '$(ctng_src)'
# tar --directory="/opt/crosstool-ng" --strip-components=1 --extract --bzip2 --file="/opt/dl/$crosstoolng"
# $(ctng_src)/configure: | $(ctng_src)/
# 	git -C '$(btrx)' cat-file -p '$(ctng_tag):$(ctng_tgz)' \
# 	| tar -C '$(ctng_src)' --xz -xf- --strip-components=1
$(ctng_src)/bootstrap: | $(ctng_src)/
	wget -O- -- '$(ctng_url)' \
	| tar -C '$(ctng_src)' -xzf- --strip-components=1

# NOTE: do it only if cloned from git
$(ctng_src)/configure: $(ctng_src)/bootstrap
	cd '$(<D)' && ./bootstrap

# ALSO:(interactive only): $ install -vDm644 -- '$(@D)/ct-ng.comp' /etc/bash_completion.d/
# $(ctng_src)/Makefile: export MAKEFLAGS :=
$(ctng_exe): $(ctng_src)/configure
	# ./configure --prefix=/opt/$(ctng_nm) && make && make install  # NOTE: only for non-local builds
	cd '$(<D)' && ./configure --enable-local && $(MAKE)


.PHONY: $(ctng_nm)-reconfigure
$(ctng_nm)-reconfigure: $(ctng_nm)-defconfig
## OR: only default samples/
# $(ctng_nm)-reconfigure: $(ctng_nm)-$(ctng_dfl)

.PHONY: $(ctng_nm)-show
$(ctng_nm)-show: $(ctng_nm)-show-$(ctng_cfg)


# MAYBE:ALT: $ --transform 'flags=r;s|^\./|$(ctng_cfg)/|'
# READ:REQ: doc/TODO.nou gh issues ※⡞⢃⢾⢦ ※⡞⢃⢿⠊ -- how to create correct cmdline to archive
.PHONY: $(ctng_nm)-archive
$(ctng_nm)-archive: | $(ctng_dst)/$(ctng_cfg)  # $(ctng_nm)-build
	tar --verbose --directory='$(ctng_dst)' --hard-dereference --compress --xz --file='$(ctng_arc)' -- '$(ctng_cfg)'


$(ctng_nm)-defconfig: export CT_BTRX_DL_SRC := $(abspath $(ctng_dl)/$(ctng_nm))
$(ctng_nm)-defconfig: export CT_BTRX_PATCHES := $(abspath $(ctng_ext)/patches)
$(ctng_nm)-defconfig $(ctng_nm)-savedefconfig \
: export DEFCONFIG := $(abspath $(ctng_set))/defconfig


$(ctng_out)/--prepare--: | $(ctng_out)/  $(ctng_dl)/$(ctng_nm)/
	ln -svfT '$(abspath $(ctng_dl)/$(ctng_nm))' '$(ctng_out)/dl'
	ln -svfT '$(abspath $(ctng_dst))' '$(ctng_out)/install'
	ln -svfT '$(abspath $(ctng_ext)/patches)' '$(ctng_out)/patches'
	touch -- '$@'


.PHONY: $(ctng_nm)-%
$(ctng_nm)-%: $(ctng_exe) $(ctng_out)/--prepare--  # $(ctng_out)/.config
	cd '$(ctng_out)' && export -n CC CXX LD_LIBRARY_PATH && '$<' $(ctng_args) '$*'
