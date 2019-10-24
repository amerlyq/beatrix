#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: preconfigured targets for cmdline batch processing (OR parallel in recursive make)
#%


.PHONY: debug
debug: _bcfg := Debug
debug: config build


.PHONY: release
release: _bcfg := RelWithDebInfo
release: config build


.PHONY: test
test: _run := testapp
test: run


.PHONY: doc
doc: doxygen  # sphinx


.PHONY: check-commit
check-commit: aspell spell reuse-all fmt

.PHONY: check-push
check-push: check-commit doc build run  #test
