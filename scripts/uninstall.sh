#!/bin/bash

if [ -f $BP/perl/.lock ]; then
    echo "The perl is locked"
    exit;
fi

rm -rf /opt/mydan/perl
