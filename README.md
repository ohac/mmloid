MMLoid for Linux

Install

    $ bundle install --path vendor/bundle

Convert an example song

    $ sudo apt-get install sox
    $ bundle exec bin/dlkoeweb
    (Download Koe-Web voices (CC BY 2.1 JP) for kaeru.mml)
    $ bundle exec bin/mmloid examples/kaeru.mml kaeru.flac -o voice/reisiuja -e sox -s

Listen to an example song

    $ play kaeru.flac

Option: get `tn_fnds` engine

    $ git clone https://github.com/ohac/tn_fnds.git
    $ cd tn_fnds/src
    $ make
    $ mv tn_fnds ../..
    $ cd -

    $ bundle exec bin/mmloid examples/kaeru.mml kaeru.flac -o voice/reisiuja -e ./tn_fnds -s

Option: Download and generate UTAU default voice (Check LICENSE before to use)

Please read http://utau2008.web.fc2.com/ before install.

    $ sudo apt-get install wine unar ruby
    $ ./download.sh
    $ ./mkdefo.sh
    $ bundle exec bin/mmloid examples/kaeru.mml kaeru.flac -o voice/oto -e ./tn_fnds -s
    $ bundle exec bin/mmloid examples/kaeru.mml kaeru.flac -o voice/oto -e resampler.exe -s
    $ bundle exec bin/mmloid examples/kaeru.mml kaeru.flac -o voice/oto -e resampler.exe

Option: Download other voices (Check LICENSE before to use)

    $ sudo add-apt-repository ppa:japaneseteam/ppa
    $ sudo apt-get update
    $ sudo apt-get install unzip
    $ ./download_kasaneteto.sh # http://kasaneteto.jp/
    $ ./download_oldvoice.sh
    $ ./download_othervoices.sh
    $ bundle exec bin/mmloid examples/kaeru.mml kaeru.flac -o voice/kasa/tan -e ./tn_fnds -s # FIXME

Option: Download other engines (Check LICENSE before to use)

    $ ./download_engines.sh
