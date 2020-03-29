#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: includes every available variable
#%
$(call &AssertVars,here)

include args.mk
include common.mk
include config.mk
include config/mod.mk
include version/mod.mk
