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
echo "${pythonpkg}" > ${pythonpkg}-extras.tcz.dep
cp ./${pythonpkg}-extras.tcz ${pythonpkg}-extras.tcz.md5.txt ${pythonpkg}-extras.tcz.dep $tcedir/optional

export PYPPETEER_HOME=/usr/local/share/pyppeteer
mkdir -p "$PYPPETEER_HOME"
/usr/local/bin/pyppeteer-install
mkdir -p $tmpdir/pkg2$PYPPETEER_HOME
(tar c -f - -C $"$PYPPETEER_HOME" . ) | tar x -O --numeric-owner -C "$tmpdir/pkg2"

pyppeteerpkg='pyppeteer'

sudo mksquashfs pkg2/ ${pyppeteerpkg}-extras.tcz
sudo chown tc:staff ${pyppeteerpkg}-extras.tcz 
md5sum ${pyppeteerpkg}-extras.tcz > ${pyppeteerpkg}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${pyppeteerpkg}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${pyppeteerpkg}-extras.tcz.list
$tceload -i ./${pyppeteerpkg}-extras.tcz
echo "${pythonpkg}" > ${pyppeteerpkg}-extras.tcz.dep
cp ./${pyppeteerpkg}-extras.tcz ${pyppeteerpkg}-extras.tcz.md5.txt ${pyppeteerpkg}-extras.tcz.dep $tcedir/optional



