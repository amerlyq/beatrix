#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: treat some targets as boolean option switches
#%

# NOTE: <keywords>: recipes with same names are ignored
@pltf := target host
@arch := arm x86_64
$(@pltf) $(@arch): ; @:

_notallowed := $(filter-out $(@pltf) $(@arch) $(PHONY),$(MAKECMDGOALS))
$(if $(_notallowed),$(error keyword or target(s) {$(_notallowed)} are not allowed, use: {$(PHONY)}))

_pltf := $(or $(filter $(@pltf),$(MAKECMDGOALS)), $(and $(ROOTFS),target), $(firstword $(@pltf)))
_arch := $(or $(filter $(@arch),$(MAKECMDGOALS)), $(ARCH), $(firstword $(@arch)))
$(if $(filter-out 0 1,$(words $(_pltf)) $(words $(_arch))),\
  $(error matrix build '[$(_pltf)] x [$(_arch)]' is not supported: use single keyword per group))

_tgts := $(filter $(PHONY),$(MAKECMDGOALS))
ifeq (,$(_tgts))
$(_pltf) $(_arch): all
endif

# ALT: any defined (even empty)
# ifneq (undefined,$(origin ARCH))
# ifeq ($(findstring arch,$(MAKECMDGOALS)),arm)
# ARCH = ...
# endif

## IDEA: nested menu / subcategory
# ifeq (console,$(firstword $(MAKECMDGOALS)))
#   CONSOLE_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS))
#   $(eval $(CONSOLE_ARGS):;@:)
# endif
# console::
#     run-some-command $(CONSOLE_ARGS)
