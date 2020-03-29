#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: includes every available target
#%
$(call &AssertVars,here)

include aspell/mod.mk
include batch.mk
include build.mk
include buildroot/mod.mk
include clang-format/mod.mk
include clang-tidy/mod.mk
include clean.mk
include cmake-format/mod.mk
include codespell/mod.mk
include configure.mk
include coverage.mk
include ctags/mod.mk
include doxygen/mod.mk
include gdb/mod.mk
include graphviz/mod.mk
include hooks/mod.mk
include install.mk
include log.mk
include pkgbuild.mk
include qemu/mod.mk
include reuse/mod.mk
include r2/mod.mk
include rr/mod.mk
include run.mk
include sanitizers.mk
include ssh/mod.mk
include t/mod.mk
include tree/mod.mk
