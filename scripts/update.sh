#!/bin/bash

OS='linux'
BU='https://raw.githubusercontent.com/MYDan/perl/master'
BP='/opt/mydan'

if [ ! -d "$BP/perl" ]; then
    echo 'Not yet installed'
fi

version=$(curl -s $BU/data/$OS/version)

if [[ $version =~ ^[0-9]{14}$ ]]; then
    echo "version: $version"
else
    echo "get version fail"
    exit;
fi

localversion=$(cat /$BP/perl/.version )

if [ "X$localversion" == "X$version" ]; then
    echo "It's the latest version";
    exit;
fi

wget -O perl.$version.tar.gz $BU/data/linux/perl.$version.tar.gz

if [ ! -e $BP ]; then
    mkdir -p $BP
fi

tar -zxvf perl.$version.tar.gz -C $BP

rm -f perl.$version.tar.gz

echo OK
