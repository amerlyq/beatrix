#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Native linux toolchain

  READ:SEIZE: https://cliutils.gitlab.io/modern-cmake/chapters/features/utilities.html

USAGE
-----

.. code-block:: bash

    cmake ... -DCMAKE_TOOLCHAIN_FILE="$PWD/$0"

#]=======================================================================]


### triple
get_filename_component(_triple ${CMAKE_CURRENT_LIST_FILE} NAME_WLE)
string(REPLACE "-" ";" _triple ${_triple})
list(GET _triple 0 _arch)
list(GET _triple 1 _vendor)
list(GET _triple 2 _sys)
list(GET _triple 3 _abi)


### toolchain
set(CMAKE_SYSTEM_PROCESSOR ${_arch})
set(CMAKE_SYSTEM_NAME Linux)


### find_*()
# Search for programs in the build host directories
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
# For libraries and headers in the target directories
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# set(CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY ON CACHE STRING "" FORCE)
# mark_as_advanced(CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY)

# set(CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY        ON CACHE STRING "" FORCE)
# mark_as_advanced(CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY)


### ccache
find_program(ccache_exe NAMES "ccache")
mark_as_advanced(ccache_exe)
if(ccache_exe)
  # ALT: set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE "${ccache_exe}")
  set(CMAKE_C_COMPILER_LAUNCHER   "${ccache_exe}" CACHE FILEPATH "")
  set(CMAKE_CXX_COMPILER_LAUNCHER "${ccache_exe}" CACHE FILEPATH "")
endif()

# https://gitlab.kitware.com/cmake/cmake/issues/16493
# CMAKE_CXX_CLANG_TIDY=clang-tidy
# CMAKE_CXX_COMPILER_LAUNCHER=ccache


### CPack
set(CPACK_GENERATOR TGZ DEB)
