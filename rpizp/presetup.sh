#!/bin/bash -xv

python='python3.9'
tceload='tce-load'
pythonpkg='python3.9'
tcedir='/mnt/sda1/tce'
tmpdir="$HOME/tmp"
mkdir -p $tmpdir
export PYPPETEER_HOME="/usr/local/share/pyppeteer"
$tceload -w ntpclient
$tceload -w chromium-browser
$tceload -w $pythonpkg
$tceload -w git
$tceload -i ntpclient
$tceload -i chromium-browser
$tceload -i $pythonpkg
$tceload -i git
$tceload -w compiletc
$tceload -w ${pythonpkg}-dev 
$tceload -w squashfs-tools 
$tceload -il compiletc
$tceload -il ${pythonpkg}-dev 
$tceload -il squashfs-tools 
$python -m ensurepip
$python -m pip install  --upgrade pip
/bin/rm -rf $tmpdir/pkg
mkdir -p "$tmpdir/pkg"
$python -m pip install pyppeteer aiohttp[speedups] --ignore-installed --root=$tmpdir/pkg

( cd $tmpdir/pkg && find usr -type d -name __pycache__  | xargs rm -rf )
( cd $tmpdir/pkg && find usr -type f -name "*.py[co]" | xargs rm -f )
cd "$tmpdir"
rm -f ${pythonpkg}-extras.tcz	
sudo mksquashfs pkg/ ${pythonpkg}-extras.tcz
sudo chown tc:staff ${pythonpkg}-extras.tcz 
md5sum ${pythonpkg}-extras.tcz > ${pythonpkg}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${pythonpkg}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${pythonpkg}-extras.tcz.list
$tceload -i ./${pythonpkg}-extras.tcz
cp ./${pythonpkg}-extras.tcz ${pythonpkg}-extras.tcz.md5.txt ${pythonpkg}-extras.tcz.dep $tcedir/optional


