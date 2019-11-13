#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: code coverage targets
#%REF: http://rc0129.blogspot.com/2018/07/tools-gcov-lcov.html
#%  DOC: https://gcc.gnu.org/onlinedocs/gcc/Invoking-Gcov.html
#%
#%HACK: write coverage .gcda even when app SEGFAULT
#%  * https://stackoverflow.com/questions/20250400/how-can-i-use-gcov-even-when-a-segmentation-fault-happens
#%  (gdb) call __gcov_flush()
#%  (gdb) print gcov_exit()
#%
#%TUT: get coverage in a cross compilation environment
#%  https://github.com/gcovr/gcovr/issues/259
#%
$(call &AssertVars,bdir CMAKE)

&at = $(shell realpath --relative-to='$(or $2,.)' -- '$(strip $1)')


#%ALIAS
.PHONY: cov coverage covx
cov: coverage
covx: coverage-clean


#%ALT:BET:PERF:(fastcov=100x): https://github.com/RPGillespie6/fastcov
#%DOC: https://www.gcovr.com/en/stable/
#%BUG: segfault with Clang -- use GCC for coverage :: $ m b r cov CC=gcc CXX=g++
# * http://lists.llvm.org/pipermail/llvm-bugs/2013-May/028304.html
# BUG:BAD: stores temporary .gcov files inside SRC dir (which may be read-only)
#   CHG! store inside bdir near *.gcda itself
.PHONY: coverage
coverage: | $(bdir)/_coverage/
	$(CMAKE) -E chdir '$|' gcovr --print-summary --root='$(call &at,$(d_pj),$|)' -- '$(call &at,$(bdir),$|)'



#%BUG: lcov still don't work with gcc=9.1
#%  https://stackoverflow.com/questions/56718554/coverage-with-gcc9-and-lcov
#%USAGE: call "coverage-invalidate" after running tests with enabled coverage
.PHONY: coverage-invalidate  coverage-info  coverage-html  coverage-open
coverage-invalidate \
coverage-info \
coverage-html \
coverage-open:
	+$(CMAKE) --build '$(bdir)' --target '$@'



.PHONY: coverage-clean
coverage-clean:
	test ! -d '$(bdir)' || find -H '$(bdir)' -type f -name '*.gcda' -delete
