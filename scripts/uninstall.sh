#!/bin/bash

INSTALLERDIR='/opt/mydan'

if [ -f $INSTALLERDIR/perl/.lock ]; then
    echo "The perl is locked"
    exit;
fi

rm -rf $INSTALLERDIR/perl
