#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: boilerplate
#%USAGE: include at the very bottom of the project root Makefile after everything else
#%

include help.mk

# NOTE: skip rebuilding of all included files
$(MAKEFILE_LIST):: ;
