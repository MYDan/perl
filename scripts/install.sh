#!/bin/bash
OS=$(uname)
PERLURL='https://raw.githubusercontent.com/MYDan/perl/master'
INSTALLERDIR='/opt/mydan'


for T in "Linux"
do
    [ "X$SO" == "X$T" ] &&  break
done

if [ "X$OS" != "X$T" ]; then
  echo "$OS : Not supported"
  exit 1
fi

if [ -f $INSTALLERDIR/perl/.lock ]; then
    echo "The perl is locked"
    exit 1;
fi

checktool() {
    if ! type $1 >/dev/null 2>&1; then
        echo "Need tool: $1"
        exit 1;  
    fi
}

checktool curl
checktool wget

if [ -d "$INSTALLERDIR/perl" ]; then
    echo 'Already installed'
    exit 1
fi

version=$(curl -s $PERLURL/data/$OS/version)
if [[ $version =~ ^[0-9]{14}$ ]];then
    echo "version: $version"
else
    echo "get version fail"
    exit;
fi


clean_exit () {
    [ -f $LOCALINSTALLER ] && rm $LOCALINSTALLER
    echo  "ERROR"
    exit $1
}

LOCALINSTALLER=$(mktemp perl.XXXXXX)

wget -O $LOCALINSTALLER $PERLURL/data/$OS/perl.$version.tar.gz || clean_exit 1

if [ ! -e $INSTALLERDIR ]; then
    mkdir -p $INSTALLERDIR
fi

tar -zxf $LOCALINSTALLER -C $INSTALLERDIR || clean_exit 1

[ -f $LOCALINSTALLER ] && rm $LOCALINSTALLER

echo OK
