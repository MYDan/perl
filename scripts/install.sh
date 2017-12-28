#!/bin/bash
OS=$(uname)
ARCH=$(uname -m)
PERLURL='https://raw.githubusercontent.com/MYDan/perl/master'
INSTALLERDIR='/opt/mydan'

for T in "Linux:x86_64" "Linux:i686" "CYGWIN_NT-6.1:x86_64" "FreeBSD:amd64" "FreeBSD:i386"
do
    o=$(echo $T|awk -F: '{print $1}')
    a=$(echo $T|awk -F: '{print $2}')
    [ "X$OS" == "X$o" ] && [ "X$ARCH" == "X$a" ]&&  break
done

if [ "X$OS" == "X$o" ] && [ "X$ARCH" == "X$a" ]; then
    echo "OS:$OS ARCH:$ARCH ok"
else
    echo "OS:$OS ARCH:$ARCH Not supported"
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
checktool md5sum

if [ -d "$INSTALLERDIR/perl" ]; then
    echo 'Already installed'
    exit 1
fi

VVVV=$(curl -s $PERLURL/data/$OS/$ARCH/version)

version=$(echo $VVVV|awk -F: '{print $1}')
md5=$(echo $VVVV|awk -F: '{print $2}')

if [[ $version =~ ^[0-9]{14}$ ]];then
    echo "perl version: $version"
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

wget -O $LOCALINSTALLER $PERLURL/data/$OS/$ARCH/perl.$version.tar.gz || clean_exit 1

fmd5=$(md5sum $LOCALINSTALLER|awk '{print $1}')

if [ "X$md5" != "X$fmd5" ];then
    echo "perl $version md5 nomatch"
    exit 1;
fi

if [ ! -e $INSTALLERDIR ]; then
    mkdir -p $INSTALLERDIR
fi

tar -zxf $LOCALINSTALLER -C $INSTALLERDIR || clean_exit 1

[ -f $LOCALINSTALLER ] && rm $LOCALINSTALLER

echo $version > $INSTALLERDIR/perl/.version

echo OK
