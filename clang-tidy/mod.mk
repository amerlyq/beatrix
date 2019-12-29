#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: modernize C/C++ source code
#%NEED: config in project root :: $ make clang-tidy-install
#%DEP:|extra/clang|
#%

.PHONY: tidy-cxx clang-tidy
#%ALIAS: [clang]            #[code modernizing]
tidy-cxx: clang-tidy        # modernize all C/C++ source files
clang-tidy: clang-tidy-all

# BUG: clang-tidy is run on everything -- even on all committed unrelated .cpp which weren't added to buildsystem
#   TRY: using exclusively integration to CMake

# BUG: error: no such file or directory: '@/path/to/_build-clang-Debug/qa_cxx_warn.flags' [clang-diagnostic-error]
#   => must ignore this cmdline argument somehow or train clang-tidy to read such cmdarg-files
#   ::: HACK:FIXED: generate separate "compile_commands.json" for clang-tidy without '@...' aggregated flags file
.PHONY: clang-tidy
clang-tidy: bdir := $(bdir)/_tidy
clang-tidy: cmake.args += -DBUILD_TESTING=OFF -DUSE_WARNINGS=OFF -DUSE_COVERAGE=OFF -DUSE_SANITIZERS=OFF
clang-tidy: config-refresh
	find '$(abspath $(d_pj))' -xtype d -name '_*' -prune -o \
	  -regextype egrep -regex '.*\.(c|h|cc|hh|cpp|hpp|cxx|hxx)' -exec \
		clang-tidy -p='$(bdir)' $(_args) {} +



.PHONY: clang-tidy-all
clang-tidy-all: _args := --checks='hicpp-*,android-*'
clang-tidy-all: clang-tidy



.PHONY: tidy-system
clang-tidy-system: _args := --system-headers
clang-tidy-system: clang-tidy



.PHONY: clang-tidy-fix
clang-tidy-fix: _args := --warnings-as-errors --fix --fix-errors
clang-tidy-fix: clang-tidy



.PHONY: clang-tidy-prof
clang-tidy-prof: _args := --enable-check-profile
clang-tidy-prof: clang-tidy



.PHONY: list-clang-tidy
list-clang-tidy:
	clang-tidy --list-checks -checks='*'



# NOTE: install config to be available for external IDE
# EXPL: this installation is "additional" i.e. not required
.PHONY: clang-tidy-install
clang-tidy-install: $(&here)cfg/custom.yaml
	ln -srviT '$<' '$(d_pj)/.clang-tidy'
