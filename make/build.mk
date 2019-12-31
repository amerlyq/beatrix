#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: build generated project
#%
$(call &AssertVars,bdir CMAKE)


.PHONY: b b1 bb bc bf
#%ALIAS: [build]            #[build step of main development flow]
b: build                    # build project inside: bdir=./_build-gcc-Debug/ (use default number of threads)
b1: build-serial            #  ... in single thread binded to single CPU core
bb: build-batch             #  ... in parallel with linux batch scheduler prio
bc: build-clean             # clean whole project target or :: tgt='a b..'
bf: build-force             # force rebuild of whole project or :: tgt='a b..'



&skiprebuild = $(if $(filter-out 0,$(B)),,$(if $(filter-out $(bgen),Ninja),/fast))


# ALSO:(VisualStudio): --config Release
# DEV:ALSO: use different recipe if found ./configure OR ./meson.build
.PHONY: build
build: $(bdir)/--configure--
ifneq (,$(wildcard ./CMakeLists.txt))
	+$(CMAKE) --build '$(bdir)' \
	  $(if $(JOBS),--parallel $(JOBS)) \
	  $(if $(CLEAN),--clean-first) \
	  $(if $(tgt),--target $(tgt:%=%$(&skiprebuild))) \
	  $(if $(build.args),-- $(build.args))
endif



## FAIL:(cmake --clean-first): always cleans whole project
#   ALT: $ cmake -P CMakeFiles/foo.dir/cmake_clean.cmake
#   BET: $ ninja -t clean <targets>
# TRY:(ADDITIONAL_CLEAN_FILES):SEE: https://gitlab.kitware.com/cmake/cmake/issues/19341
#   https://gitlab.kitware.com/cmake/cmake/issues/17074
.PHONY: build-clean
build-clean: $(bdir)/--configure--
	+$(CMAKE) --build '$(bdir)' -- -t clean $(tgt)



#%USAGE:(workflow): fixing compilation warnings $ m bf tgt=LibStatic
.PHONY: build-force
build-force: build-clean build



# ALSO: $ sudo nice -n -4 ...
.PHONY: build-serial
build-serial: CMAKE := taskset --cpu-list 1 $(CMAKE)
build-serial: JOBS := 1
build-serial: build



## JOBS:
# DFL:(-- -j '$(shell nproc)'): propagate top-level "make -j4" into underlying make
#   OR:BET: extract "-j4" from ctl and pass it again to actual tool (e.g. ninja OR:BET: cmake --parallel)
#   OR user ENV VARs e.g. MAKEFLAGS by using "+$(CMAKE)"
#   OR cmake --parallel "$(nproc)"
#   OR export CMAKE_BUILD_PARALLEL_LEVEL := $(shell nproc)
.PHONY: build-batch
build-batch: CMAKE := chrt --batch 0 $(CMAKE)
build-batch: JOBS = $(shell nproc)
build-batch: build
