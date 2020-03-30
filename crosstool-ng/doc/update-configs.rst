.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: CC-BY-SA-4.0

Update configs
==============

TODO: write how to save/update only "fragments"

Crosstool-NG
------------

Initial::

   ct-ng nconfig
   ct-ng savedefconfig

.. warning::
   Some local variables may be filtered-out by "savedefconfig" and must be added back.
   SEE: ./crosstool-ng/scripts/saveSample.sh:44: … PREFIX_DIR LOCAL_TARBALLS_DIR SAVE_TARBALLS …

Upgrade legacy::

   ct-ng upgradeconfig
   # WARN: carefully read output
   ct-ng savedefconfig
