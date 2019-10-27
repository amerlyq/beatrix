#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: reformat C/C++ source code
#%DEP:|extra/clang|
#%

# CHECK:WARN: source code in workdir is reformatted BUT! commit is unchanged
#   => (intentionally) manually amend your commit OR make new commit with style format
# CHECK! grep output "no changes" and exit error if not
.PHONY: fmt
fmt:
	! git clang-format | grep -vxF -e 'no modified files to format' -e "clang-format did not modify any files"



.PHONY: fmt-all
fmt-all:
	find . -xtype d -name '_*' -prune -o \
	  -regextype egrep -regex '.*\.(cpp|hpp|cc|cxx)' -exec \
	    clang-format --verbose -style=file --fallback-style=none -i {} +
