#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: cmake-specific and user-defined targets
#%
$(call &AssertVars,bcfg bdir btrx btst brun CMAKE)

# _bgen := Unix Makefiles
_bgen := Ninja
_bcfg := $(bcfg)
_bini := $(or $(bini),$(btrx)cmake/config/default.cmake)
_bdir := $(bdir)
_run  := $(brun)

# RQ: to run tests inside installed dir -- you still must know defaults
#   CASE: not all tools are possible to run as custom commands from inside CMake
d_install = $(_bdir)/_install

tname := x86_64-pc-linux-gnu.cmake
toolchain := $(btrx)/cmake/toolchain/$(tname)

cmake_args += $(if $(VERBOSE),-Wdev -Wno-error=dev)

&skiprebuild := $(if $(filter-out 0,$(B)),,$(if $(filter-out $(_bgen),Ninja),/fast))


#%ALIAS
.PHONY: b c gv lc ll r t
b: build
c: config
gv: graphviz
lc: list-cachevars
ll: list-cachevars-all
r: run
t: test


.PHONY: config
config \
$(_bdir)/CMakeCache.txt:
	$(CMAKE) $(cmake_args) \
	  $(if $(_bgen),-G'$(_bgen)') \
	  $(if $(_bini),-C'$(_bini)') \
	  -S'$(d_pj)' \
	  -B'$(_bdir)' \
	  $(if $(_toolchain),-DCMAKE_TOOLCHAIN_FILE='$(toolchain)') \
	  -DCMAKE_INSTALL_PREFIX='$(d_install)' \
	  -DCMAKE_BUILD_TYPE='$(_bcfg)' \
	  -DBUILD_TESTING='$(btst)' \
	  -DUSE_SANITIZERS='$(_saint)'



.PHONY: list-cachevars
list-cachevars:
	$(CMAKE) -L$(if $(VERBOSE),H) '$(_bdir)'

.PHONY: list-cachevars-all
list-cachevars-all:
	$(CMAKE) -LA$(if $(VERBOSE),H) '$(_bdir)'



# VisualStudio: --target myapp --config Release --clean-first
# BET:(-- -j '$(shell nproc)'): propagate top-level "make -j4" OR user ENV VARs by using "+$(CMAKE)"
.PHONY: build
build: $(_bdir)/CMakeCache.txt
	+$(CMAKE) --build '$(_bdir)'



.PHONY: install
install:
	+$(CMAKE) --build '$(_bdir)' --target install



# ALT: install then run :: $(abspath $(_bdir))/_install/bin/main
.PHONY: run
run: _tgt = run.$(or $(X),$(_run))
run: coverage-invalidate
	+$(CMAKE) --build '$(_bdir)' --target '$(_tgt)$(&skiprebuild)' -- $(_args)



#%NOTE: specialized env vars required by sanitizers in runtime
.PHONY: saint
# INFO: decode ASAN backtrace after using "symbolize=0"
#   $ projects/compiler-rt/lib/asan/scripts/asan_symbolize.py / <./log | c++filt
saint: export ASAN_OPTIONS := check_initialization_order=1
# NOTE:(poison_in_dtor=1): required by -fsanitize-memory-use-after-dtor
saint: export MSAN_OPTIONS := poison_in_dtor=1
saint: export UBSAN_OPTIONS := print_stacktrace=1
saint: _saint := $(or $(SANITIZER),$(error "You must specify enabled SANITIZER=..."))
saint: config build run



#%USAGE: call "coverage-invalidate" after running tests with enabled coverage
_covtgts := $(patsubst %,coverage-%,invalidate info html open)
.PHONY: $(_covtgts)
$(_covtgts):
	+$(CMAKE) --build '$(_bdir)' --target '$@'



## BAD: always rebuilds whole project and never runs tests at all
##   $ ctest --build-and-test '$(d_pj)' '$(_bdir)' --build-generator "Unix Makefiles" --build-nocmake --build-noclean --output-on-failure --build-project runtests
.PHONY: ctest
ctest:
	+$(CMAKE) --build '$(_bdir)' --target testapp -- ARGS="--output-on-failure"



.PHONY: graphviz
graphviz: _pfx = $(_bdir)/_gv/g
graphviz: cmake_args += --graphviz='$(_pfx)'
graphviz: config
	find '$(_pfx)' -type f -name 'g*' -execdir mv '{}' '{}.gv' \;
	graphviz-view '$(_pfx).gv'
