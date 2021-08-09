#!/bin/sh

for i in "$@"
do
  case "$i" in
  (-i|--input|-in)
    tee <&0 | clip.exe
    exit 0
    ;;
  esac
done
