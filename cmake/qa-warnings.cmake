#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Entry point to add warnings flags

#]=======================================================================]

# ALT: directly add flags to each of CMAKE vars
#   BAD: repeated flags from "*-both" will be specified twice
set(qa_warn)
set(qa_c_warn)
set(qa_cxx_warn)


# TODO: remove all flags beside (Wall Wextra) from Release build
#   => to not affect code itself by "-f..." dep-flags
include(qa-warnings-both)


# ALT:USE: add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/MP>")
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  include(qa-warnings-gnu)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  include(qa-warnings-clang)
endif()


# TODO: split on debug/release set by: {performance, aim, applicability}
#   i.e. CMAKE_CXX_FLAGS_{DEBUG,RELEASE,RELWITHDEBINFO}
# [_] BUG: warning flags are propagated to ext-deps compilation
string(REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS};${qa_c_warn};${qa_warn}")
string(REPLACE ";" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS};${qa_cxx_warn};${qa_warn}")
