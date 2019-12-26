#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: includes every available target
#%
$(call &AssertVars,here)

include aspell.mk
include batch.mk
include build.mk
include clang-format.mk
include clang-tidy.mk
include clean.mk
include cmake-format.mk
include codespell.mk
include configure.mk
include coverage.mk
include doxygen.mk
include gdb/mod.mk
include git.mk
include graphviz.mk
include install.mk
include log.mk
include pkgbuild.mk
include reuse.mk
include rr.mk
include run.mk
include sanitizers.mk
include tags.mk
include tree.mk
