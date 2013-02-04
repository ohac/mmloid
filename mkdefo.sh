#!/bin/bash
dd if=/dev/zero of=oto.ntfs.img count=10 bs=1024k
LOOPDEV=`sudo losetup -f`
sudo losetup $LOOPDEV oto.ntfs.img
sudo mkfs.ntfs $LOOPDEV
mkdir -p oto.ntfs
mkdir -p voice/oto
sudo mount -t ntfs -o codepage=cp932 $LOOPDEV oto.ntfs
cp AquesTalk.dll mkdefo.exe resampler.exe oto.ntfs
cd oto.ntfs
wine mkdefo.exe
ls *.wav | xargs -i wine resampler.exe {} dummy 0 0
cp -f *.wav *.frq ../voice/oto
cd ..
sudo umount oto.ntfs
rm -r oto.ntfs
rm -f oto.ntfs.img
