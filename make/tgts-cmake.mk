#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: cmake-specific and user-defined targets
#%
$(call &AssertVars,bcfg bdir btst brun CMAKE)

_bcfg := $(bcfg)
_bdir := $(bdir)
_run  := $(brun)

cmake_args += $(if $(VERBOSE),-Wdev -Wno-error=dev)


.PHONY: config
config \
$(_bdir)/CMakeCache.txt:
ifeq (,)
	$(CMAKE) '$(d_pj)' -B'$(_bdir)' $(cmake_args) \
	  -DCMAKE_BUILD_TYPE='$(_bcfg)' \
	  -DBUILD_TESTING='$(btst)' \
	  -DCMAKE_INSTALL_PREFIX='$(_bdir)/_install' \

else
# 	  -DCMAKE_TOOLCHAIN_FILE='$(f_toolchain)' \
# 	  -DCMAKE_INSTALL_PREFIX='$(STAGING_DIR)/usr' \
# 	  -DCMAKE_SYSROOT='$(STAGING_DIR)' \
# 	  -DPLATFORM_ARCH='$(ARCH)'
endif



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
run: _tgt = run_$(or $(X),$(_run))$(if $(filter-out 0,$(B)),,/fast)
run: _args = $(if $(W),WRAP='$(W)') $(if $(G),ARGS="--gtest_filter='$(G)'")
run:
	+$(CMAKE) --build '$(_bdir)' --target '$(_tgt)' -- $(_args)



.PHONY: coverage
coverage:
	+$(CMAKE) --build '$(_bdir)' --target coverage



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
