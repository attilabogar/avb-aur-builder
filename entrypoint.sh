#!/bin/bash
# vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab:
set -euo pipefail

function setup_user() {
  groupadd --gid $GID user
  useradd user \
         --shell /bin/bash  \
         --create-home \
         --uid $UID --gid $GID
  echo 'user:user' | chpasswd
  gpasswd -a user wheel
}

grep -q ^MAKEFLAGS= /etc/makepkg.conf || echo MAKEFLAGS=\"-j$(nproc)\" >> /etc/makepkg.conf
getent passwd user > /dev/null || setup_user
sudo --user=user --set-home /build-helper.sh $PKGNAME
