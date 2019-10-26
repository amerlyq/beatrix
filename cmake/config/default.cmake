#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Default set of variables to populate initial CMakeCache.txt in build directory.

Keep alphabetical.

#]=======================================================================]

set(CMAKE_BUILD_TYPE "RelWithDebInfo"
  CACHE STRING "Artifacts build type")

# ALT:(cross): "$(STAGING_DIR)/usr" -DCMAKE_SYSROOT='$(STAGING_DIR)'
set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/_install"
  CACHE PATH "Directory to install produced artifacts")

set(BUILD_TESTING ON
  CACHE BOOL "Enable tests-related stuff")

# HACK: suppress "variables were not used" warnings
set(CMAKE_TOOLCHAIN_FILE ""
  CACHE FILEPATH "")
