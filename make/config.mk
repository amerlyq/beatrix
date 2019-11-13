#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: project defaults (common variables)
#%

### --- Toolchain ---

# BET: use toolchain even for native builds
# toolchain_cmake := $(btrx)cmake/toolchain-$(triplet).cmake
# toolchain_mk    := $(btrx)make/toolchain-$(triplet).mk

# TEMP: override only through "make CXX=..." -- otherwise "./m" and "make" produce different compilers
# BAD: ignores CXX from environment
CC ?= clang
export CC

CXX ?= clang++
export CXX

$(if $(VERBOSE),$(shell >&2 echo 'CC=$(CC) CXX=$(CXX)'))


### --- Environment ---
# TODO: https://clang-analyzer.llvm.org/scan-build
# ATT! you must rebuild project to scan it e.g. scan-build make -B
# CMAKE := scan-build cmake
CMAKE := cmake
SANITIZER ?= memory

$(if $(W),$(eval 'export WRAP := $(W)'))
$(if $(G),$(eval 'export ARGS := --gtest_filter=$(G)'))


### --- Options ---
# hosts := x86_64 mingw64 arm32 sanitized


### --- Arguments ---
# bgen := Unix Makefiles
bgen := Ninja
bcfg ?= Debug
bdir := _build-$(CC)-$(bcfg)
btst := ON
force := 1
