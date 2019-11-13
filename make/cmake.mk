#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: cmake-specific and user-defined targets
#%
$(call &AssertVars,bcfg bdir btrx btst brun CMAKE)

bini := $(btrx)cmake/config/default.cmake

# RQ: to run tests inside installed dir -- you still must know defaults
#   CASE: not all tools are possible to run as custom commands from inside CMake
# INFO:(system): DFL=/usr
prefix = $(bdir)/_install

tname := x86_64-pc-linux-gnu.cmake
toolchain := $(btrx)/cmake/toolchain/$(tname)

cmake_args += $(if $(VERBOSE),-Wdev -Wno-error=dev)

&skiprebuild := $(if $(filter-out 0,$(B)),,$(if $(filter-out $(bgen),Ninja),/fast))


.PHONY: b c cc gv lc lC lt lT r t
#%ALIAS: [cmake]            #[cmake-related stuff]
b: build                    # build project inside: bdir=./_build-gcc-Debug/
c: config                   # configurate cmake with generator: bgen=Ninja
cc: config-refresh          # reconfigurate cmake (e.g. to apply new env vars)
gv: graphviz                # generate cmake projects dependency graph
lc: list-cachevars          # list cmake variables cached inside build dir
lC: list-cachevars-all      #  ... together with advanced (hidden) categories
lt: list-targets            # list project generated build targets
lT: list-targets-all        #  ... together with cmake auto-generated default targets
r: run                      # run chosen executable of current project: brun=Main
t: test                     # run testapp with unit tests (RQ: btst=ON)



# USAGE:(rebuild): $ make config -B
# ALT:FAIL:(%/_stamp/--AAA---): can't mix normal (alias) and implicit rules
.PHONY: config config-refresh
config: $(bdir)/--configure--
config-refresh \
$(bdir)/--configure--:
	echo $(bdir)
	$(CMAKE) $(cmake_args) \
	  $(if $(bgen),-G'$(bgen)') \
	  $(if $(bini),-C'$(bini)') \
	  -S'$(d_pj)' \
	  -B'$(bdir)' \
	  $(if $(_toolchain),-DCMAKE_TOOLCHAIN_FILE='$(toolchain)') \
	  -DCMAKE_INSTALL_PREFIX='$(prefix)' \
	  -DCMAKE_BUILD_TYPE='$(bcfg)' \
	  -DBUILD_TESTING='$(btst)' \
	  -DUSE_SANITIZERS='$(_saint)'
	@touch -- '$(bdir)/--configure--'



.PHONY: list-cachevars
list-cachevars:
	$(CMAKE) -L$(if $(VERBOSE),H) '$(bdir)'

.PHONY: list-cachevars-all
list-cachevars-all:
	$(CMAKE) -LA$(if $(VERBOSE),H) '$(bdir)'


.PHONY: list-targets
list-targets:
	ninja -C '$(bdir)' -t targets

.PHONY: list-targets-all
list-targets-all:
	ninja -C '$(bdir)' -t targets all



# VisualStudio: --target myapp --config Release --clean-first
# BET:(-- -j '$(shell nproc)'): propagate top-level "make -j4" OR user ENV VARs by using "+$(CMAKE)"
.PHONY: build
build: $(bdir)/--configure--
	+$(CMAKE) --build '$(bdir)'



# ALT: install then run :: $(abspath $(bdir))/_install/bin/main
.PHONY: run
run: _tgt = run.$(or $(X),$(brun))
run: coverage-invalidate
	+$(CMAKE) --build '$(bdir)' --target '$(_tgt)$(&skiprebuild)' -- $(_args)



#%NOTE: specialized env vars required by sanitizers in runtime
.PHONY: saint
# INFO: decode ASAN backtrace after using "symbolize=0"
#   $ projects/compiler-rt/lib/asan/scripts/asan_symbolize.py / <./log | c++filt
saint: export ASAN_OPTIONS := check_initialization_order=1
# NOTE:(poison_in_dtor=1): required by -fsanitize-memory-use-after-dtor
saint: export MSAN_OPTIONS := poison_in_dtor=1
saint: export UBSAN_OPTIONS := print_stacktrace=1
saint: _saint := $(or $(SANITIZER),$(error "You must specify enabled SANITIZER=..."))
saint: config-refresh build run



## BAD: always rebuilds whole project and never runs tests at all
##   $ ctest --build-and-test '$(d_pj)' '$(bdir)' --build-generator "Unix Makefiles" --build-nocmake --build-noclean --output-on-failure --build-project runtests
.PHONY: ctest
ctest:
	+$(CMAKE) --build '$(bdir)' --target testapp -- ARGS="--output-on-failure"



.PHONY: graphviz
graphviz: _pfx = $(bdir)/_gv/g
graphviz: cmake_args += --graphviz='$(_pfx)'
graphviz: config
	find '$(_pfx)' -type f -name 'g*' -execdir mv '{}' '{}.gv' \;
	graphviz-view '$(_pfx).gv'
