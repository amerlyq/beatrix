#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: preconfigured targets for cmdline batch processing (OR parallel in recursive make)
#%

#%ALIAS
.PHONY: ck
ck: check-all


.PHONY: test
test: _run := testapp
test: run


.PHONY: doc
doc: doxygen  # sphinx


# EXPL: tidy everything -- all languages of project at once
.PHONY: tidy
tidy: tidy-cxx


.PHONY: check-basic
check-basic: \
  aspell-index \
  codespell \
  reuse-all \
  clang-format-index


# ALT(#test): use "run" with brun=test
# BAD: "doc" target creates dubious "_build-clang-Debug/_doxy" directory in *beatrix*
# BUT: "clang-tidy-all" is very slow
#   MAYBE: use more lightweight "check-most" for git-push-hook, and run "tidy" only by explicit "check-all" ?
# BAD! can't gradually accumulate targets throughout all files -- because order matters
#   ALT: split targets between barriers and force dependency on barrier
.PHONY: check-all
check-all: \
  aspell-all \
  codespell \
  reuse-all \
  test-self \
  clang-tidy-all \
  clang-format-all \
  doc \
  build \
  run \
  #test
