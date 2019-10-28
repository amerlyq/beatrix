# vim:ft=sh
#
# SPDX-FileCopyrightText: 2019 Dmytro Kolomoiets <amerlyq@gmail.com> and contributors.
#
# SPDX-License-Identifier: MIT
#
# Maintainer: Dmytro Kolomoiets <amerlyq@gmail.com>
#
# shellcheck shell=bash disable=SC2034,SC2154
pkgbase=beatrix
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

## AUR:
optdepends=(
  reuse
  rr
  cmake-format-airy-git
)

package() {
  d_pj=${startdir%/*/*/*}/beatrix
  prefix=$pkgdir/usr
  datadir=$prefix/share
  cd "$d_pj" || exit
  # make install prefix="$prefix"
  install -Dm644 -t "$datadir/licenses/$pkgbase" -- $(printf 'LICENSES/%s.txt\n' "${license[@]}")
  install -Dm644 -t "$datadir/doc/$pkgbase" -- README.rst
}
