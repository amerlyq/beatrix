#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: preconfigured targets for cmdline batch processing (OR parallel in recursive make)
#%

#%ALIAS
.PHONY: ck cov
ck: check-all
cov: coverage


.PHONY: debug
debug: bcfg := Debug
debug: config build


.PHONY: release
release: bcfg := RelWithDebInfo
release: config build


.PHONY: test
test: _run := testapp
test: run


.PHONY: coverage
coverage: coverage-html


.PHONY: doc
doc: doxygen  # sphinx


.PHONY: check-basic
check-basic: aspell-index spell reuse-all fmt

.PHONY: check-all
check-all: check-basic doc build run  #test
