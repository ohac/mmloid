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
  wget http://utau2008.xrea.jp/defaultvoice.uar
fi
# unzip for japanese http://www.ubuntulinux.jp/japanese
unzip defaultvoice.uar
unzip utau0416installer.zip
unar utau0416inst.exe
rm utau0416inst.exe
unar utau0416inst/utaustup.msi
rm -fr utau0416inst
CAB=`file utaustup/* | grep Cabi | cut -d : -f 1`
unar $CAB
rm -fr utaustup
mkdir -p ut
file `basename $CAB`/* | grep able..console | cut -d : -f 1 | xargs -i mv {} ut
rm -fr `basename $CAB`
mv `grep -l resampler.exe ut/*` resampler.exe
mv `grep -l wavtool2 ut/*` wavtool2.exe
rm -fr ut
