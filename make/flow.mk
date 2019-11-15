#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: main development flow / REPL
#%
$(call &AssertVars,bdir brun CMAKE)

&skiprebuild := $(if $(filter-out 0,$(B)),,$(if $(filter-out $(bgen),Ninja),/fast))


.PHONY: b r t
#%ALIAS: [flow]             #[main development flow]
b: build                    # build project inside: bdir=./_build-gcc-Debug/
r: run                      # run chosen executable of current project: brun=Main
t: test                     # run testapp with unit tests (RQ: btst=ON)



# VisualStudio: --target myapp --config Release --clean-first
# BET:(-- -j '$(shell nproc)'): propagate top-level "make -j4" OR user ENV VARs by using "+$(CMAKE)"
.PHONY: build
build: $(bdir)/--configure--
	+$(CMAKE) --build '$(bdir)'



# WARN! must always launch executable targets exclusively through CMake
#   <= to generate timestamps, etc. and run dependent actions (e.g. coverage)
# ALT: install then run :: $(abspath $(bdir))/_install/bin/main
# THINK: add dependency on "$(bdir)/--configure--" to prevent error "build dir does not exists" or not
# TRY:DEV: combine "run" with "build" into generic "cmake-target" :: $(if $(_tgt),--taget $(_tgt)..)
.PHONY: run
run: _tgt = run.$(or $(X),$(brun))
run: $(bdir)/--configure--
	+$(CMAKE) --build '$(bdir)' --target '$(_tgt)$(&skiprebuild)' -- $(_args)



## BAD: always rebuilds whole project and never runs tests at all
##   $ ctest --build-and-test '$(d_pj)' '$(bdir)' --build-generator "Unix Makefiles" --build-nocmake --build-noclean --output-on-failure --build-project runtests
.PHONY: ctest
ctest:
	+$(CMAKE) --build '$(bdir)' --target testapp -- ARGS="--output-on-failure"
