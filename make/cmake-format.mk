#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: reformat CMake configuration files
#%DEP:|aur/cmake-format|
#%
$(call &AssertVars,btrx)

.PHONY: fmt-cmake
fmt-cmake:
	find . -xtype d -name '_*' -prune -o \
	  \( -name '*.cmake' -o -name 'CMakeLists.txt' \) -exec \
	    cmake-format --config-files '$(btrx)/style/cmake-format-closure' --in-place -- {} +
