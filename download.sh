#!/bin/bash
which unar
if [ $? -eq 1 ]; then
  echo "unar is not found."
  exit
fi
if ! [ -a "utau0416installer.zip" ]; then
  echo "Please read http://utau2008.web.fc2.com/ before install."
  sleep 3
  wget http://utau2008.xrea.jp/utau0416installer.zip
fi
# unzip for japanese http://www.ubuntulinux.jp/japanese
unzip utau0416installer.zip
unar utau0416inst.exe
rm utau0416inst.exe
unar utau0416inst/utaustup.msi
rm -fr utau0416inst
CAB=`file utaustup/* | grep Cabi | cut -d : -f 1`
unar $CAB
rm -fr utaustup
mkdir -p ut
CABHOME=`basename $CAB`
file $CABHOME/* | grep able..console | cut -d : -f 1 | xargs -i mv {} ut
mkdir -p oto
grep -l AquesTalk_FreeWave $CABHOME/* | xargs -i mv {} oto/AquesTalk.dll
grep -l FREQ `grep -l wav= $CABHOME/*` | xargs -i mv {} oto/oto.ini
rm -fr $CABHOME
mv `grep -l resampler.exe ut/*` resampler.exe
mv `grep -l wavtool2 ut/*` wavtool2.exe
mv `grep -l AquesTalk ut/*` oto/mkdefo.exe
rm -fr ut
cd oto
LANG=C wine mkdefo.exe
# TODO rename generated filenames
