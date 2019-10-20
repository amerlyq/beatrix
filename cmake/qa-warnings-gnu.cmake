#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

All useful flags for up to GCC 8.1 (beside included into -Wall -Wextra)

REF
---

* https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
* https://gcc.gnu.org/onlinedocs/gcc/C-Dialect-Options.html
* https://gcc.gnu.org/onlinedocs/gcc/C_002b_002b-Dialect-Options.html

#]=======================================================================]

list(APPEND qa_warn
  -pedantic-errors
  # -Wchkp  -fcheck-pointer-bounds  # THINK:RQ: -mmpx
  -Wlogical-op
  -Wstack-usage=1024  -fstack-usage
  -Wtrampolines
  -Wvector-operation-performance
  ## Advices
  # -Wsuggest-attribute=const  # BAD: requires gcc-specific [[gnu::const]] modifier
)

list(APPEND qa_cxx_warn
  -Wuseless-cast
  -Wnoexcept
  -Wstrict-null-sentinel
)


if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "5.0.0")
list(APPEND qa_warn
  -Wdate-time
  ## Advices
  -Wsuggest-final-types
  -Wsuggest-final-methods

  ## DISABLED: wrongly requires "override final" instead of simple "final"
  ## BET:USE: clang build to search for missed "override" instead
  # -Wsuggest-override
)
list(APPEND qa_cxx_warn
  -Wconditionally-supported
)
endif()


if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "6.0.0")
list(APPEND qa_warn
  -Wshift-overflow=2
  -Wshift-negative-value
  -Wnull-dereference
  -Wduplicated-cond
)
list(APPEND qa_cxx_warn
  -Wvirtual-inheritance
  ## Advices
  # -Wtemplates
  # -Wmultiple-inheritance
)
endif()


if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "7.0.0")
list(APPEND qa_warn
  -Wunused-macros
  -Wstringop-overflow=4
  -Wduplicated-branches
  -Walloc-zero
  -Walloca
)
endif()


if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "8.0.0")
list(APPEND qa_warn
  -Wcast-align=strict
  -Wstringop-truncation
)
list(APPEND qa_cxx_warn
  -Wextra-semi
)
endif()
