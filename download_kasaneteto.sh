#!/bin/bash
if ! [ -a "TETO-tougou-110401.zip" ]; then
  wget http://kasaneteto.jp/ongendl/index.cgi/renzoku/TETO-tougou-110401.zip
  #wget http://kasaneteto.jp/ongendl/index.cgi/tandoku/TETO-tandoku-100619.zip
  #wget http://kasaneteto.jp/ongendl/index.cgi/extra/TETO-rikimitan-120930.zip
  #wget http://kasaneteto.jp/ongendl/index.cgi/extra/TETO-sakebi-120930.zip
  #wget http://kasaneteto.jp/ongendl/index.cgi/extra/TETO-sasayakitougou-110917.zip
  #wget http://kasaneteto.jp/ongendl/index.cgi/extra/TETO-extra-100619.zip
fi
unzip TETO-tougou-110401.zip
mkdir -p voice
mv 重音テト音声ライブラリー/ voice/kasa
mv install.txt voice/kasa
cd voice/kasa
mv 重音テトエクストラ ext
mv 重音テト公式ロゴ logo
mv 重音テト単独音 tan
mv 重音テト連続音 ren
cd ../..
