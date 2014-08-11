MMLoid for Linux

Download Koe-Web voices for kaeru.mml

    ruby download_koeweb.rb

Convert an example song

    ruby bin/mmloid examples/kaeru.mml kaeru.flac -o voice/reisiuja -e sox -s

Listen to an example song

    play kaeru.flac

Option: get `tn_fnds` engine

    git clone https://github.com/ohac/tn_fnds.git
    cd tn_fnds/src
    make

    ruby bin/mmloid examples/kaeru.mml kaeru.flac -o voice/reisiuja -e ./tn_fnds -s

Option: Download and generate UTAU default voice (Check LISENCE before to use)

Please read http://utau2008.web.fc2.com/ before install.

    sudo apt-get install wine unar ruby sox
    ./download.sh
    ./mkdefo.sh

Option: Download other voices (Check LISENCE before to use)

    sudo add-apt-repository ppa:japaneseteam/ppa
    sudo apt-get update
    sudo apt-get install unzip
    ./download_kasaneteto.sh # http://kasaneteto.jp/
    ./download_oldvoice.sh
    ./download_othervoices.sh

Option: Download other engines (Check LISENCE before to use)

    ./download_engines.sh
