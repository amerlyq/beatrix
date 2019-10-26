# vim:ft=sh
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
# Maintainer: Dmytro Kolomoiets <amerlyq@gmail.com>
#
# shellcheck shell=bash disable=SC2034,SC2154
pkgname=beatrix-dev
pkgver=0.1
pkgrel=1
pkgdesc='Project control panel (dev-environ)'
url='https://github.com/amerlyq/beatrix/'
license=('MIT' 'Apache-2.0' 'CC-BY-SA-4.0')
arch=('any')

depends=(
  clang cmake ctags gdb git moreutils ninja rr tree

  dcd dfmt dmd dmd-docs dscanner dtools
)

d_pj=${startdir%/*/*}

package() {
  cd "$d_pj/beatrix" || exit
  # make PREFIX=/usr DESTDIR="${pkgdir}" install
  install -Dm644 -t "${pkgdir}/usr/share/licenses/beatrix" -- \
    $(printf 'LICENSES/%s.txt\n' "${license[@]}")
  install -Dm644 -t "${pkgdir}/usr/share/doc/beatrix" -- README.rst
}
