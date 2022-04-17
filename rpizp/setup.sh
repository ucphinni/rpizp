#!/bin/bash -xv

python='python3.9'
tceload='tce-load'
pythonpkg='python3.9'
tmpdir="$HOME/tmp"
mkdir -p "$tmpdir"
export PYPPETEER_HOME="$tmpdir/pkg/usr/local/share/pyppetteer"
$tceload -wic ntpclient $pythonpkg
$tceload -w compiletc ${pythonpkg}-dev  squashfs-tools git
$tceload -il compiletc ${pythonpkg}-dev  squashfs-tools git
$python -m ensurepip
$python -m pip install  --upgrade pip
/bin/rm -rf $tmpdir/pkg
mkdir -p $tmpdir/pkg
$python -m pip install pyppeteer aiohttp[speedups] --ignore-installed --root=$tmpdir/pkg

( cd $tmpdir/pkg && find usr -type d -name __pycache__  | xargs rm -rf )
( cd $tmpdir/pkg && find usr -type f -name "*.py[co]" | xargs rm -f )
mkdir -p "$PYPPETEER_HOME"
$tmpdir/pkg/usr/local/bin/pyppeteer-install
cd $tmpdir
rm -f ${pythonpkg}-extras.tcz	
sudo mksquashfs pkg/ ${pythonpkg}-extras.tcz
sudo chown tc:staff ${pythonpkg}-extras.tcz 
md5sum ${pythonpkg}-extras.tcz > ${pythonpkg}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${pythonpkg}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${pythonpkg}-extras.tcz.list
$tceload -ic ./${pythonpkg}-extras.tcz
