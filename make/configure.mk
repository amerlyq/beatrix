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
$(call &AssertVars,bcfg bdir bini bpfx btst CMAKE)

.PHONY: c cc cg ct lc lC lt lT
#%ALIAS: [configure]        #[configuration and generation steps]
c: config                   # configure cmake with generator: bgen=Ninja
                            # {reconfigure cmake} (e.g. to apply new env vars)
cc: config-cli              #  ... by command line interface (CLI) USAGE: $ make cc cmake.args="-D'KEY=VALUE' ..."
cg: config-gui              #  ... by graphical user interface (GUI)
ct: config-tui              #  ... by terminal user interface (TUI)
lc: list-cachevars          # list cmake variables cached inside build dir
lC: list-cachevars-all      #  ... together with advanced (hidden) categories
lt: list-targets            # list project generated build targets
lT: list-targets-all        #  ... together with cmake auto-generated default targets


cmake_cmd = $(CMAKE) \
  $(if $(VERBOSE),-Wdev -Wno-error=dev) \
  $(if $(WARN),--warn-uninitialized --warn-unused-vars) \
  $(if $(DEBUG),--debug-output)



# ALT:FAIL:(%/_stamp/--AAA---): can't mix normal (alias) and implicit rules
.PHONY: config config-refresh
config: $(bdir)/--configure--
config-refresh \
$(bdir)/--configure--:
	$(cmake_cmd) -S'$(d_pj)' -B'$(bdir)' \
	  $(if $(bgen),-G'$(bgen)') \
	  $(if $(bini),-C'$(bini)') \
	  $(if $(toolchain_cmake),-DCMAKE_TOOLCHAIN_FILE='$(toolchain_cmake)') \
	  -DCMAKE_INSTALL_PREFIX='$(bpfx)' \
	  -DCMAKE_BUILD_TYPE='$(bcfg)' \
	  -DBUILD_TESTING='$(btst)' \
	  -DUSE_COVERAGE='$(brun)' \
	  -DUSE_SANITIZERS='$(_saint)' \
	  $(cmake.args)
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
