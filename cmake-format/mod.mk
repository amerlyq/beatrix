#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: reformat CMake configuration files
#%DEP:|aur/cmake-format|
#%
$(call &AssertVars,&here)


.PHONY: fmt-cmake
#%ALIAS: [aux]
fmt-cmake: cmake-format



# THINK: skip and don't format embedded "beatrix" pj
.PHONY: cmake-format
cmake-format: $(&here)cfg/closure.py
	find . -xtype d -name '_*' -prune -o \
	  \( -name '*.cmake' -o -name 'CMakeLists.txt' \) -exec \
	    cmake-format --config-files '$<' --in-place -- {} +
