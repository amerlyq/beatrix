#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Entry point to add warnings flags

TRY:(never use CMAKE_CXX_FLAGS): https://cmake.org/pipermail/cmake/2017-August/066044.html

#]=======================================================================]
include_guard(DIRECTORY)


option(USE_WERROR "Treat warnings as errors" ON)
if(USE_WERROR)
  add_compile_options(-Werror)
endif()

option(USE_WARNINGS "Extra compilation warnings" ON)
if(NOT USE_WARNINGS)
  return()
endif()



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
function(dump_flags_from_var lang var)
  # RQ:(absolute path): on configure step file is used to build CMakeDetermineCompilerABI_C.bin
  set(fout "${CMAKE_CURRENT_BINARY_DIR}/${var}.flags")
  set(flags ${${var}} ${qa_warn})
  list(SORT flags)

  string(REPLACE ";" "\n" flags "${flags}")
  file(WRITE "${fout}" "${flags}")

  string(TOUPPER "${lang}" lang)
  set(dst CMAKE_${lang}_FLAGS)
  set(${dst} "${${dst}} @${fout}" PARENT_SCOPE)
endfunction()


## ALT: more simple and transparent
# string(REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS};${qa_c_warn};${qa_warn}")
# string(REPLACE ";" " " CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS};${qa_cxx_warn};${qa_warn}")
dump_flags_from_var(C qa_c_warn)
dump_flags_from_var(CXX qa_cxx_warn)
