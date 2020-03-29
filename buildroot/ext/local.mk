#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY: override .tar.gz archives (e.g. for FOSS packages) by locally changed repos
#%ALG: buidroot rsync -> ./output/build/<package>-custom/

# LINUX_OVERRIDE_SRCDIR = $(BTRX_TOP_DIR)/linux-kernel/
# BUSYBOX_OVERRIDE_SRCDIR = $(BTRX_TOP_DIR)/busybox/
