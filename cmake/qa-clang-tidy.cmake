#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Enable clang-tidy checks

REF: https://gitlab.kitware.com/cmake/cmake/issues/18926


What’s wrong with the CMake integration?

  REF: https://sarcasm.github.io/notes/dev/clang-tidy.html

* Constant overhead for compilation in development.
  - For development linting is nice before committing, but not necessarily when iterating on the code.
* If you want to modernize/fix your code, you need another way to run clang-tidy anyway.
* No way to force colors.
  - This may actually be a missing feature in clang-tidy, which lacks something like -fdiagnostic-colors.


#]=======================================================================]

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

find_program(CLANG_TIDY_COMMAND NAMES clang-tidy)


set(CMAKE_CXX_CLANG_TIDY
  ${CLANG_TIDY_COMMAND}
  "-checks=-*,modernize-*,-modernize-use-trailing-return-type"
  "-header-filter='${CMAKE_SOURCE_DIR}/.*'"
)
