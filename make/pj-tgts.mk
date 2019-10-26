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
include clang-format.mk
include clean.mk
include cmake-format.mk
include cmake.mk
include codespell.mk
include doxygen.mk
include gdb.mk
include git.mk
include log.mk
include pkgbuild.mk
include reuse.mk
include rr.mk
include tags.mk
include tree.mk
