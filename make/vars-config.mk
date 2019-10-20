#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: project defaults (common variables)
#%

### --- Toolchain ---

# BET: use toolchain even for native builds
# toolchain_cmake := $(btrx)/cmake/toolchain-$(triplet).cmake
# toolchain_mk    := $(btrx)/make/toolchain-$(triplet).mk

CC ?= clang
export CC

CXX ?= clang++
export CXX

$(if $(VERBOSE),$(warning 'CC=$(CC) CXX=$(CXX)'))


### --- Environment ---
# TODO: https://clang-analyzer.llvm.org/scan-build
# CMAKE := scan-build cmake
CMAKE := cmake


### --- Options ---
# hosts := x86_64 mingw64 arm32 sanitized


### --- Arguments ---
bcfg := Debug
bdir := _build-$(CC)-$(bcfg)
btst := ON
# force :=
