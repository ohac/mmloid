#!/bin/bash
if ! [ -a "defaultvoice.uar" ]; then
  wget http://utau2008.xrea.jp/defaultvoice.uar
fi
unzip defaultvoice.uar
mkdir -p voice
mv oto voice/oto.old
mv install.txt voice/oto.old
