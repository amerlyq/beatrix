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
include clang-format.mk
include clang-tidy.mk
include clean.mk
include cmake-format.mk
include codespell/mod.mk
include configure.mk
include coverage.mk
include ctags/mod.mk
include doxygen.mk
include gdb/mod.mk
include git.mk
include graphviz.mk
include install.mk
include log.mk
include pkgbuild.mk
include reuse/mod.mk
include r2/mod.mk
include rr/mod.mk
include run.mk
include sanitizers.mk
include tree.mk
