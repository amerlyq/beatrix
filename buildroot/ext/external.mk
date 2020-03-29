#
# SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
#%SUMMARY:RQ: list of additional packages for buildroot

include $(sort $(wildcard $(BR2_EXTERNAL_BTRX_PATH)/package/*/*.mk))
include $(sort $(wildcard $(BR2_EXTERNAL_BTRX_PATH)/toolchain/*/*.mk))

#%OFF:
# flash-my-board:
# 	$(BR2_EXTERNAL_BTRX_PATH)/board/my-board/flash-image \
# 	  --image $(BINARIES_DIR)/image.bin \
# 	  --address $(BTRX_FLASH_ADDR)


#%HACK:(fast dev-cycle): additional target w/o image packing
.PHONY: build-only
build-only: $(TARGETS)
