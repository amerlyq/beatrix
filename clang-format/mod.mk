#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: reformat C/C++ source code
#%NEED: config in project root :: $ make clang-format-install
#%DEP:|extra/clang|
#%ONLINE: interactive config composer REF: https://clangformat.com/
#%
$(call &AssertVars,d_pj &here)



.PHONY: fmt fmti clang-format
#%ALIAS: [clang]            #[code formatting]
fmt: clang-format           # reformat all C/C++ source files
fmti: clang-format-index    # reformat only files added to "git index"
clang-format: clang-format-all



# CHECK:WARN: source code in workdir is reformatted BUT! commit is unchanged
#   => (intentionally) manually amend your commit OR make new commit with style format
# CHECK! grep output "no changes" and exit error if not
.PHONY: clang-format-index
clang-format-index:
	! git clang-format | grep -vxF -e 'no modified files to format' -e "clang-format did not modify any files"



# FIXME: don't rely on ".clang-format" in project root
#   -- always use config directly from this dir (or from user private overlay)
.PHONY: clang-format-all
clang-format-all:
	find . -xtype d -name '_*' -prune -o \
	  -regextype egrep -regex '.*\.(cpp|hpp|cc|cxx)' -exec \
	    clang-format --verbose -style=file --fallback-style=none -i {} +



# NOTE: install config to be available for external IDE
# EXPL: this installation is "additional" i.e. not required
.PHONY: clang-format-install
clang-format-install: $(&here)cfg/vertical.yaml
	ln -srviT '$<' '$(d_pj)/.clang-format'


# FAIL! global private var with same name becomes overriden
# .cfg := $(&here)cfg/vertical.yaml
# .PHONY: clang-format-install
# clang-format-install:
# 	ln -srviT '$(.cfg)' '$(d_pj)/.clang-format'
