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


.PHONY: check-basic
check-basic: \
  aspell-index \
  codespell \
  reuse-all \
  clang-format-index


# BUT: "clang-tidy-all" is very slow
#   MAYBE: use more lightweight "check-most" for git-push-hook, and run "tidy" only by explicit "check-all" ?
.PHONY: check-all
check-all: \
  aspell-all \
  codespell \
  reuse-all \
  clang-tidy-all \
  clang-format-all \
  doc \
  build \
  run \
  #test
