.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: CC-BY-SA-4.0

#######
Patches
#######

Place in this dir tarball local patches to be overlaid on top
(or injected into) base patchset of ``ct-ng``::

   /opt/crosstool-ng/patches
   ├── crosstool-ng
   │   ├── 0001-Fix-makelevel-recursion.patch.patch
   │   └── ...
   └── eglibc
      └── 2_19
         ├── 0001-Add-0001-R_ARM_TLS_DTPOFF32.patch.patch
         ├── 0002-Add-eglibc-linaro-2.19-2014.04.patch.patch
         └── ...

NOTE: custom folder ``crosstool-ng`` is actually used to patch ``ct-ng`` itself
after unpacking and ignored by ``ct-ng`` own build system.
