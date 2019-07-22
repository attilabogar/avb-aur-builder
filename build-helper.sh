#!/bin/bash
# vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab:
set -euo pipefail

function rebuild_repo() {
  pushd .
  cd /data/repo
  local repo=repo
  rm -f $repo.db{,.tar.gz,.tar.gz.old} $repo.files{,.tar.gz,.tar.gz.old}
  repo-add $repo.db.tar.gz *.pkg.tar.xz || repo-add $repo.db.tar.gz
  rm -f $repo.{db,files}
  cp -pv $repo.db.tar.gz $repo.db
  cp -pv $repo.files.tar.gz $repo.files
  popd
}


build_pkg() {
  cd /data/build/"$1"
  ( . PKGBUILD ; for key in "${validpgpkeys[@]}"; do gpg --recv-keys "$key" ; done ) || :
  sudo pacman -Syy
  makepkg --noconfirm --cleanbuild -s
  cp -p *.pkg.tar.xz /data/repo/
  rebuild_repo
}

rebuild_repo

if ! [[ -d "/data/build/$1" ]]
then
  # there is no package source under /data/build/$1
  # check for my own aur override
  code=$(curl -L -s -o /dev/null -w "%{http_code}" "https://raw.githubusercontent.com/attilabogar/avb-aur/master/${1}/PKGBUILD")
  if [[ $code -eq 200 ]]
  then
    cd /tmp
    git clone https://github.com/attilabogar/avb-aur.git
    cd avb-aur
    cp -pr "$1" /data/build/
  else
    # we get the official AUR package
    curl -R -L -o "/tmp/$1.tar.gz" \
      "https://aur.archlinux.org/cgit/aur.git/snapshot/$1.tar.gz"
    tar -C /data/build/ -xzf "/tmp/$1.tar.gz"
  fi
fi

build_pkg "$1"
