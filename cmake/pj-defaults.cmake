#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Default configuration of project CMake

REF
---

* READ: https://cmake.org/documentation/
    https://habr.com/ru/post/461817/
* READ:(style): https://cmake.org/cmake/help/v3.16/manual/cmake-developer.7.html
* READ:(large files): https://blog.kitware.com/cmake-externaldata-using-large-files-with-distributed-version-control/
* NICE:E.G. https://github.com/fmtlib/fmt/blob/master/CMakeLists.txt

#]=======================================================================]


# WARN: build type must be always specified from outside
set(known_build_types Debug Release RelWithDebInfo MinSizeRel)
if(NOT CMAKE_BUILD_TYPE IN_LIST known_build_types)
  message(FATAL_ERROR "Unknown or empty build type=${CMAKE_BUILD_TYPE}")
endif()


# EXPL:(pkg-config): search in prebuilt ext-deps prefix first
set(PKG_CONFIG_USE_CMAKE_PREFIX_PATH ON)


# EXPL:(-std=c++20): enable instead of -std=gnu++20
if(NOT CMAKE_CXX_EXTENSIONS)
  set(CMAKE_CXX_EXTENSIONS OFF)
endif()
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# EXPL:(-std=c11): enable instead of -std=gnu11
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)


# EXPL:(compile_commands.json): generate cmdline database in build directory
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)


# EXPL:(-pthread): declare program-wide to affect ext-deps linking
set(THREADS_PREFER_PTHREAD_FLAG TRUE)
set(THREADS_PTHREAD_ARG "2" CACHE STRING "" FORCE)
