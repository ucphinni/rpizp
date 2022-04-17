#!/bin/bash -xv

python='python3.9'
tceload='tce-load'
pythonpkg='python3.9'
tmpdir="$HOME/tmp"
mkdir -p "$tmpdir"
export PYPPETEER_HOME="$tmpdir/pkg/usr/local/share/pyppetteer"
$tceload -w ntpclient
$tceload -w $pythonpkg
$tceload -w git
$tceload -ic ntpclient
$tceload -ic $pythonpkg
$tceload -ic git
$tceload -w compiletc
$tceload -w ${pythonpkg}-dev 
$tceload -w squashfs-tools 
$tceload -il compiletc
$tceload -il ${pythonpkg}-dev 
$tceload -il squashfs-tools 
$python -m ensurepip
$python -m pip install  --upgrade pip
/bin/rm -rf $tmpdir/pkg
mkdir -p $tmpdir/pkg
$python -m pip install pyppeteer aiohttp[speedups] --ignore-installed --root=$tmpdir/pkg

( cd $tmpdir/pkg && find usr -type d -name __pycache__  | xargs rm -rf )
( cd $tmpdir/pkg && find usr -type f -name "*.py[co]" | xargs rm -f )
cd $tmpdir
rm -f ${pythonpkg}-extras_tmp.tcz	
sudo mksquashfs pkg/ ${pythonpkg}-extras_tmp.tcz
sudo chown tc:staff ${pythonpkg}-extras_tmp.tcz 
md5sum ${pythonpkg}-extras.tcz > ${pythonpkg}-extras_tmp.tcz.md5.txt
unsquashfs -ll -d '' ${pythonpkg}-extras_tmp.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${pythonpkg}-extras.tcz.list
$tceload -il ./${pythonpkg}-extras_tmp.tcz

mkdir -p "$PYPPETEER_HOME"
$tmpdir/pkg/usr/local/bin/pyppeteer-install

rm -f ${pythonpkg}-extras.tcz	
sudo mksquashfs pkg/ ${pythonpkg}-extras.tcz
sudo chown tc:staff ${pythonpkg}-extras.tcz 
md5sum ${pythonpkg}-extras.tcz > ${pythonpkg}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${pythonpkg}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${pythonpkg}-extras.tcz.list
$tceload -ic ./${pythonpkg}-extras.tcz