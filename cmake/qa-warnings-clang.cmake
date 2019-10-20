#[=======================================================================[.rst:

.. SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: MIT

SUMMARY
-------

All useful flags for up to Clang 7.0 (everything beside included into -Wall -Wextra)

REF
---

* https://clang.llvm.org/docs/DiagnosticsReference.html
* https://releases.llvm.org/9.0.0/tools/clang/docs/DiagnosticsReference.html

#]=======================================================================]


### clang>=5.0
list(APPEND qa_warn
  -Werror=option-ignored
  -Warc-repeated-use-of-weak
  -Wbitfield-enum-conversion
  -Wc++11-compat-pedantic
  -Wclass-varargs
  -Wconditional-uninitialized
  -Wthread-safety
  -Wdate-time
  ## Mistakes
  -Wconsumed
  -Wdirect-ivar-access
  -Wdisabled-macro-expansion
  -Wembedded-directive
  -Wexit-time-destructors
  -Wexpansion-to-defined
  -Wformat-pedantic
  -Wframe-larger-than=1024
  -Widiomatic-parentheses
  -Winconsistent-missing-destructor-override
  -Winfinite-recursion
  -Wloop-analysis
  -Wmethod-signatures
  -Wmismatched-tags
  -Wmissing-braces
  -Wmissing-prototypes
  -Wmissing-variable-declarations
  -Wmost
  -Wmove
  -Wnonportable-system-include-path
  -Wnull-dereference
  -Wnull-pointer-arithmetic
  -Wover-aligned
  -Woverriding-method-mismatch
  -Wpch-date-time
  -Wpragmas
  -Wreserved-id-macro
  -Wreserved-user-defined-literal
  -Wretained-language-linkage
  -Wsemicolon-before-method-body
  -Wshift-overflow
  -Wshift-negative-value
  -Wsometimes-uninitialized
  -Wstring-conversion
  -Wsuper-class-method-mismatch
  -Wtautological-compare
  -Wundefined-reinterpret-cast
  -Wunreachable-code
  -Wunreachable-code-break
  -Wunreachable-code-loop-increment
  -Wunreachable-code-return
  -Wunused-macros
  -Wvector-conversion
  ## Sanitizing
  -Wcomma
  -Wduplicate-enum
  -Wduplicate-method-arg
  -Wduplicate-method-match
  -Wdynamic-exception-spec
  -Wempty-translation-unit
  -Wexplicit-ownership-type
  -Wignored-qualifiers
  -Wimplicit
  -Wkeyword-macro
  -Wnewline-eof
  -Wredundant-parens
  -Wstatic-in-inline
  -Wstrict-prototypes
  -Wweak-template-vtables
  -Wweak-vtables
  -Wzero-length-array
  ## Arrays
  -Warray-bounds-pointer-arithmetic
  # -Wextended-offsetof  # OBSOLETE:(clang>=6.0)
  -Wflexible-array-extensions
  ## Arithmetic
  -Wfloat-conversion
  -Wfloat-overflow-conversion
  -Wfloat-zero-conversion
  -Wshorten-64-to-32
  -Wsign-compare
  -Wsign-conversion
  ## Advices
  -Wcomment
  -Wdocumentation
  -Wdocumentation-pedantic
  -Wglobal-constructors
  -Wgnu
  # -Wheader-hygiene
  -Wunneeded-internal-declaration
  -Wunneeded-member-function
  -Wvla

  ## THINK: enable for "shared" legacy files only
  # -Wc++98-c++11-c++14-compat-pedantic
  # -Wlocal-type-template-args
  # -Wno-c++98-compat-local-type-template-args
)


if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL "6.0.0")
list(APPEND qa_cxx_warn
  -Wextra-semi
)
endif()
