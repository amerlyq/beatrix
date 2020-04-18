.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: CC-BY-SA-4.0

configs
=======

Additional custom configs corresponding to boards.

HACK: keep here only relative symlinks to each `board/<cfg>/defconfig`.
Such setup is introduced for better coupling between files of single `<cfg>` feature.

FAIL: when saved through buildroot -- all symlinks here are replaced by actual file.
  ALT: add to config BR2_DEFCONFIG="$(BTRX_BR2_SET_DIR)/defconfig"
    NICE: configs are written to correct location by "savedefconfig"
    BAD: options itself is stripped -- so you must insert this line each time again

[_] TODO: remove .license symlinks when reuse:#205 is merged
