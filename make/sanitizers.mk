#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: rebuild and analyze code by chosen sanitizer
#%
$(call &AssertVars,CMAKE)


#%NOTE: specialized env vars required by sanitizers in runtime
.PHONY: saint
# INFO: decode ASAN backtrace after using "symbolize=0"
#   $ projects/compiler-rt/lib/asan/scripts/asan_symbolize.py / <./log | c++filt
saint: export ASAN_OPTIONS := check_initialization_order=1
# NOTE:(poison_in_dtor=1): required by -fsanitize-memory-use-after-dtor
saint: export MSAN_OPTIONS := poison_in_dtor=1
saint: export UBSAN_OPTIONS := print_stacktrace=1
saint: _saint := $(or $(SANITIZER),$(error "You must specify enabled SANITIZER=..."))
saint: config-refresh build run
