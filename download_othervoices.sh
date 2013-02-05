#!/bin/bash
if ! [ -a "nagonemako_a2.uar" ]; then
  wget http://utau2008.xrea.jp/nagonemako_a2.uar
  wget http://utau2008.xrea.jp/momoneA.zip
  wget http://utau2008.xrea.jp/man2.zip
  wget http://utau2008.xrea.jp/koe.zip
  wget http://utau2008.xrea.jp/downloads/defo/defota.zip
  wget http://utau2008.xrea.jp/loliedit.zip
fi
mkdir -p voice
#unzip nagonemako_a2.uar
#mv 和音マコＡ voice/nago
#mv install.txt voice/nago
#unzip momoneA.zip
#mv ももねA voice/momo
#unzip man2.zip
#mv man2 voice/
#unzip koe.zip
#mv koe voice/
#unzip defota.zip
#mv defota voice/
#mkdir loli.tmp
#cd loli.tmp
#unzip ../loliedit.zip
#cd ..
#mv loli.tmp/oto voice/loli
#mv loli.tmp/* voice/loli
#rm -r loli.tmp
