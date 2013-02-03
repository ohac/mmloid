#!/bin/bash
if ! [ -a "defaultvoice.uar" ]; then
  wget http://utau2008.xrea.jp/defaultvoice.uar
fi
mkdir -p voice
cd voice
unzip ../defaultvoice.uar
cd ..
