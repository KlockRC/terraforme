#!/bin/bash
#
#
# automaçao DNS e WEB e DHCP e EMAIL e FTP e QUOTA
# Ruan Cesar e Mylena torquato
#
#
#

list="/etc/apt/sources.list"




echo "------------------------------------souce-list-------------------------------"
        echo "[ 1. debian 10 ]"
        echo ""
        echo "[ 2. debian 11 ]"
        echo ""
        echo "[ 3. debian 12 ]"
        echo ""
        echo "[ 4. voltar ]"
        echo ""
        echo "echolha uma das opções"
        read opn2
        echo "------------------------------------------------------------------------------"
    case "$opn2" in
        1)
            echo "deb http://deb.debian.org/debian buster main contrib non-free" > $list
            echo "deb-src http://deb.debian.org/debian buster main contrib non-free" >> $list
            sleep 2
            ;;
        2)
            echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > $list
            echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free" >> $list
            sleep 2
            ;;
        3)
            echo "deb http://deb.debian.org/debian bookworm main non-free-firmware" > $list
            echo "deb-src http://deb.debian.org/debian bookworm main non-free-firmware" >> $list
            sleep 2
            ;;
        4)
            echo "voltando para o menu"
            sleep 2
            menu
            ;;
        *)
            echo "opção invalida"
            ;;
    esac



