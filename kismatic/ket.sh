#!/usr/bin/env bash
# Usage: ket.sh install [version]
#        ket.sh remove

VERSION=${2:-"v1.9.2"}

case $1 in
  "install")
    tarball=kismatic-${VERSION}-`uname|tr 'A-Z' 'a-z'`-amd64.tar.gz
    curl -OL https://github.com/apprenda/kismatic/releases/download/${VERSION}/${tarball}
    tar zxf ${tarball}
  ;;
  "remove")
    rm helm kismatic kubectl provision kismatic-*-amd64.tar.gz
    rm -r ansible/ generated/ runs/
  ;;
esac
