#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: cmake configuration + generation steps
#%USAGE:
#%  rebuild $ make cc
#%     ALT: $ make config -B
#%
$(call &AssertVars,bcfg bdir btrx btst CMAKE)

bini := $(btrx)cmake/config/default.cmake

# RQ: to run tests inside installed dir -- you still must know defaults
#   CASE: not all tools are possible to run as custom commands from inside CMake
# INFO:(system): DFL=/usr
prefix = $(bdir)/_install

tname := x86_64-pc-linux-gnu.cmake
toolchain := $(btrx)/cmake/toolchain/$(tname)

cmake_args += $(if $(VERBOSE),-Wdev -Wno-error=dev)


.PHONY: c cc cg ct lc lC lt lT
#%ALIAS: [configure]        #[configuration and generation steps]
c: config                   # configure cmake with generator: bgen=Ninja
                            # {reconfigure cmake} (e.g. to apply new env vars)
cc: config-cli              #  ... by command line interface (CLI) USAGE: $ make cc cmake_args="-D'KEY=VALUE' ..."
cg: config-gui              #  ... by graphical user interface (GUI)
ct: config-tui              #  ... by terminal user interface (TUI)
lc: list-cachevars          # list cmake variables cached inside build dir
lC: list-cachevars-all      #  ... together with advanced (hidden) categories
lt: list-targets            # list project generated build targets
lT: list-targets-all        #  ... together with cmake auto-generated default targets



# ALT:FAIL:(%/_stamp/--AAA---): can't mix normal (alias) and implicit rules
.PHONY: config config-refresh
config: $(bdir)/--configure--
config-refresh \
$(bdir)/--configure--:
	$(CMAKE) -S'$(d_pj)' -B'$(bdir)' \
	  $(if $(bgen),-G'$(bgen)') \
	  $(if $(bini),-C'$(bini)') \
	  $(if $(_toolchain),-DCMAKE_TOOLCHAIN_FILE='$(toolchain)') \
	  -DCMAKE_INSTALL_PREFIX='$(prefix)' \
	  -DCMAKE_BUILD_TYPE='$(bcfg)' \
	  -DBUILD_TESTING='$(btst)' \
	  -DUSE_SANITIZERS='$(_saint)' \
	  $(cmake_args)
	@touch -- '$(bdir)/--configure--'



.PHONY: config-cli
config-cli: CMAKE := cmake
config-cli: config-refresh

# BAD: "gui" ignores "-D..." options passed on cmdline -- must change them manually by GUI
.PHONY: config-gui
config-gui: CMAKE := cmake-gui
config-gui: config-refresh

.PHONY: config-tui
config-tui: CMAKE := ccmake
config-tui: config-refresh



.PHONY: list-cachevars
list-cachevars:
	$(CMAKE) -L$(if $(VERBOSE),H) '$(bdir)'

.PHONY: list-cachevars-all
list-cachevars-all:
	$(CMAKE) -LA$(if $(VERBOSE),H) '$(bdir)'


.PHONY: list-generators
list-generators:
	$(CMAKE) --help | sed -n '/^Generators$$/,$$p'


.PHONY: list-targets
list-targets:
	ninja -C '$(bdir)' -t targets

.PHONY: list-targets-all
list-targets-all:
	ninja -C '$(bdir)' -t targets all
