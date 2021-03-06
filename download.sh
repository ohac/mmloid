#!/bin/bash
which unar
if [ $? -eq 1 ]; then
  echo "unar is not found."
  exit
fi
if ! [ -a "utau0416installer.zip" ]; then
  echo "Please read http://utau2008.web.fc2.com/ before install."
  sleep 3
  wget http://utau2008.xrea.jp/utau0418e-inst.zip
fi
# unzip for japanese http://www.ubuntulinux.jp/japanese
unzip utau0418e-inst.zip
unar utau0418e-inst.exe
rm utau0418e-inst.exe
unar utau0418e-inst/utaustup.msi
rm -fr utau0418e-inst
CAB=`file utaustup/* | grep Cabi | cut -d : -f 1`
unar $CAB
rm -fr utaustup
mkdir -p ut
CABHOME=`basename $CAB`
file $CABHOME/* | grep able..console | cut -d : -f 1 | xargs -i mv {} ut
grep -l AquesTalk_FreeWave $CABHOME/* | xargs -i mv {} AquesTalk.dll
mkdir -p voice/oto
grep -l wav= $CABHOME/* | xargs -i mv {} voice/oto/
cat voice/oto/_* | grep --binary-files=text wav | \
    nkf -w | grep -o '[[:print:]]*.wav=[[:print:]]*' | \
    nkf -s > voice/oto/oto.ini
grep -l wav= $CABHOME/* | xargs -i mv {} voice/oto/
rm -fr $CABHOME
mv -f `grep -l resampler.exe ut/*` resampler.exe
mv -f `grep -l wavtool2 ut/*` wavtool2.exe
mv -f `grep -l AquesTalk ut/*` mkdefo.exe
rm -fr ut
