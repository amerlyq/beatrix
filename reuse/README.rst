.. SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.

.. SPDX-License-Identifier: CC-BY-SA-4.0

LICENSING
=========

Check presence of licensing information (for legal compliance)::

   reuse lint

Add missing SPDX annotations (with current year) into header comments or separate `*.license` file::

   reuse addheader -c 'UserName <user@example.com>' -l MIT -s python -- ./feature/mod.mk
   reuse download GPL-2.0-only
   reuse addheader -c 'UserName <user@example.com>' -l GPL-2.0-only --explicit-license -- ./feature/archive.tar.gz

Example::

   #
   # SPDX-FileCopyrightText: 2020 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
   #
   # SPDX-License-Identifier: Apache-2.0
   #

See more details on REUSE v3.0+ specification and SPDX v2.1+ annotations

* https://github.com/fsfe/reuse-tool
* https://reuse.software/spec/
* https://spdx.org/spdx-specification-21-web-version
