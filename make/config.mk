#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: project defaults (common variables)
#%DEV:IDEA: targets "make {def|define} bcfg=..." to change/store "config.mk" defaults in pj root
#%  ALSO:NEED: ignored "personal.mk" to override project-wide settings by private uncommitted settings
#%

### --- Toolchain ---

# BET: use toolchain even for native builds
triplet := x86_64-pc-linux-gnu
toolchain_cmake = $(btrx)cmake/toolchain/$(triplet).cmake
# toolchain_mk    = $(btrx)make/toolchain/$(triplet).mk

# TEMP: override only through "make CXX=..." -- otherwise "./m" and "make" produce different compilers
# BAD: ignores CXX from environment
CC ?= clang
export CC

CXX ?= clang++
export CXX

# THINK: useless because it's printed by CMake on "configure" step
# NEED: $(TRACE) to *only* print executed recipes cmdlines without other verbose info
$(if $(VERBOSE),$(shell >&2 echo 'CC=$(CC) CXX=$(CXX)'))


### --- Environment ---
# MOVE: combine with other launchers like "cmake-gui"
# TODO: https://clang-analyzer.llvm.org/scan-build
# ATT! you must rebuild project to scan it e.g. scan-build make -B
# CMAKE := scan-build cmake
CMAKE := cmake
SANITIZER ?= memory

$(if $(W),$(eval run.wrap := $(W)))
$(if $(G),$(eval run.args := --gtest_filter='$(G)'))


### --- Options ---
# hosts := x86_64 mingw64 arm32 sanitized


### --- Arguments ---

# FIXME: treat separately cmdline args $(p|pfx) from global vars $(bpfx|gpfx),
#   optional recipe keys $(opfx) and temporary internals-override only $(_pfx)
# i.e. use {pfx -> gpfx -> _pfx -> opfx} to prevent parasitic overrides
# ALSO:DEV(shortcuts): @b=build.args, @c=cmake.args, A=@r=run.args W=@w=run.wrap G=@g=gtest.args X=brun T=g_tgts
bcfg ?= Debug
bdir := _build-$(CC)-$(bcfg)
# bgen := Unix Makefiles
bgen := Ninja
bini := $(btrx)cmake/config/default.cmake
# INFO:(system): DFL=/usr
bpfx = $(bdir)/_install
btst := ON
force := 1
cmpt :=
