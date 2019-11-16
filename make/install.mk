#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: install artifacts of current build type
#%
$(call &AssertVars,bpfx bdir CMAKE)


.PHONY: i ia ic id ip ir it ix
#%ALIAS: [install]    #[build artifacts]
i: install-default    # default install recipe parametrized by "cmpt=..."
ia: install-all       # install all named components {develop,package,runtime}
ic: install-check     # show results of clean install
id: install-develop   # cmpt=develop
ip: install-package   # cmpt=package
ir: install-runtime   # cmpt=runtime
it: install-tree      # show artifacts structure installed into filesystem
ix: install-clean     # clean-up content of install directory



.PHONY: install-default
install-default: install


.PHONY: install-check
install-check: install-clean install-default install-tree


# MAYBE:CHG: use "args.mk" to set current installation component for the only
#  common "install" target
.PHONY: install-develop
install-develop: cmpt := develop


## TRY: install group of different components at once instead of defining twice
#   https://cmake.org/pipermail/cmake/2008-August/023313.html
.PHONY: install-package
install-package: cmpt := package


# WARN: must use bcfg=Release to install some of "runtime" components
.PHONY: install-runtime
install-runtime: cmpt := runtime


.PHONY: install-all
install-all: \
  install-develop \
  install-package \
  install-runtime \


## NOTE: env var "VERBOSE" implies flag "--verbose"
## ALT: +$(CMAKE) --build '$(bdir)' --target install
#  OR: cmake -DCOMPONENT=development -P cmake_install.cmake
#  OR: https://cmake.org/pipermail/cmake/2008-June/022516.html
# ALSO:(opt): --prefix "${i:=$bdir/_install}"
.PHONY: install
install-develop \
install-package \
install-runtime \
install:
	+$(CMAKE) --install '$(bdir)' \
	  $(if $(STRIP),--strip) \
	  $(if $(cmpt),--component $(cmpt))


.PHONY: install-clean
install-clean:
	test ! -d '$(bpfx)' || find -H '$(bpfx)' -delete


.PHONY: install-tree
install-tree: export LC_ALL=C
install-tree:
	tree --noreport -aAC --prune --matchdirs --dirsfirst -- '$(bpfx)'
