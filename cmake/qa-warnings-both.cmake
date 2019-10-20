#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

Common flags available in both GCC and Clang

#]=======================================================================]


### Main
list(APPEND qa_warn
  -Wall  # MAYBE: -Wno-unused-variable -Wno-unused-but-set-parameter
  -Wextra
  -Wpedantic
  -Wuninitialized
  -Wmissing-include-dirs
  -Wshadow
  -Wundef
  -Winvalid-pch
)

### Extra
list(APPEND qa_warn
  ## Control flow
  -Winit-self
  -Wswitch-enum  -Wswitch-default
  -Wformat=2  -Wformat-nonliteral  -Wformat-security  -Wformat-y2k
  ## Arithmetic
  -Wdouble-promotion
  -Wfloat-equal
  -Wpointer-arith
  ## Cast and conversion
  -Wstrict-overflow=5
  -Wcast-qual
  -Wcast-align
  -Wconversion
  -Wpacked
  ## Sanitizing
  -Wstrict-aliasing  -fstrict-aliasing
  -Wredundant-decls
  -Wmissing-declarations
  -Wmissing-field-initializers
  ## Security
  -Wwrite-strings
  # -Wstack-protector  -fstack-protector  # TEMP:DISABLED: we have questionable usage of arrays < 8 bytes everywhere
  -Wpadded
  -Winline
  -Wdisabled-optimization
)

list(APPEND qa_c_warn
  -Waggregate-return
  -Wbad-function-cast
  -Wc++-compat
)

list(APPEND qa_cxx_warn
  # -Weffc++  # BAD: requires init std::string(), etc in ctor BUT: some checks are useful
  -Wzero-as-null-pointer-constant
  -Wctor-dtor-privacy
  # OBSOLETE: -Wsign-promo
  -Wold-style-cast
  -Woverloaded-virtual
)
