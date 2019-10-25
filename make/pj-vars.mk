#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: includes every available variable
#%
$(call &AssertVars,here)

include common.mk
# include args.mk
include config.mk
include version.mk
