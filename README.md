UTAU for linux

Please read http://utau2008.web.fc2.com/ before install.

    sudo apt-get install wine unar ruby
    ./download.sh
    ./mkdefo.sh

Convert an example song

    ruby bin/utau4linux

Listen to an example song

    play oto.wav

Option: Download other voices (Check LISENCE before use)

    sudo add-apt-repository ppa:japaneseteam/ppa
    sudo apt-get update
    sudo apt-get install unzip
    ./download_kasaneteto.sh # http://kasaneteto.jp/
    ./download_oldvoice.sh
    ./download_othervoices.sh

Option: Download other engines (Check LISENCE before use)

    ./download_engines.sh
