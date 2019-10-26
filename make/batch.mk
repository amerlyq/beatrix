#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: preconfigured targets for cmdline batch processing (OR parallel in recursive make)
#%

#%ALIAS
.PHONY: cov
cov: coverage


.PHONY: debug
debug: _bcfg := Debug
debug: config build


.PHONY: release
release: _bcfg := RelWithDebInfo
release: config build


.PHONY: test
test: _run := testapp
test: run


.PHONY: coverage
coverage: coverage-html


.PHONY: doc
doc: doxygen  # sphinx


# RENAME: check-basic/common + check-all
.PHONY: check-commit
check-commit: aspell spell reuse-all fmt

.PHONY: check-push
check-push: check-commit doc build run  #test
