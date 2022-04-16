#!/bin/sh

python='python3.9'
tceload='tce-load'

$tceload -wic chromium-browser ntpclient python3.9
$tceload -wil compiletc python3.9-dev  squashfs-tools git
$python -m ensurepip
$python -m pip install --upgrade pip
mkdir -p /tmp/pkg
$python -m pip install pyppeteer aiohttp[speedups] --root=/tmp/pkg
( cd /tmp/pkg && find usr \( -type d -name pycache -exec rm -rf {}  \) -o \( -type f -name "*.py[co]" \) \; ) 
cd /tmp 
sudo mksquashfs pkg/ python3.9-extras.tcz
sudo chown tc:staff python3.9-extras.tcz 
md5sum python3.9-extras.tcz > python3.9-extras.tcz.md5.txt
unsquashfs -ll -d '' python3.9-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > python3.9-extras.tcz.list
$tceload -wic ./python3.9-extras.tcz
