#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Enable colors in Ninja.

REF: https://medium.com/@alasher/colored-c-compiler-output-with-ninja-clang-gcc-10bfe7f2b949

#]=======================================================================]

if(CMAKE_GENERATOR STREQUAL "Ninja")
  set(_colors ON)
endif()


option(COMPILER_COLORS_FORCE "Always produce ANSI-colored output (GNU/Clang only)" ${_colors})


# BAD: interferes with "vim -q" when loading compiler errors for quickfix analysis
if(COMPILER_COLORS_FORCE)
  if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_compile_options(-fdiagnostics-color=always)
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_options(-fcolor-diagnostics)
  endif()
endif()
