#!/bin/bash
# vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab:
set -euo pipefail

function usage() {
  echo "$0: <pkglist.txt|aurpackage>+"
  exit 1
}

function drop_repo() {
  rm -rf ./repo/
  mkdir -p ./repo
  touch ./repo/.gitkeep
}

function clean_workspace() {
  rm -rf ./workspace/ || :
  mkdir -p ./workspace
  touch ./workspace/.gitkeep
}

function build() {
  docker-compose down || :
  MYUID=$(id -u) MYGID=$(id -g) PKGNAME="$1" docker-compose up --exit-code-from build && docker-compose down
  return $?
}

[[ $# -eq 0 ]] && usage

#drop_repo
clean_workspace

while [[ $# -gt 0 ]]
do
  if [[ -d "$1" ]]
  then
    cp -pr "$1" ./workspace/
    build "$1"
  elif [[ -s "$1" ]]
  then
    while read l
    do
      build "$l"
    done < "$1"
  else
    build "$1"
  fi
  shift
done
