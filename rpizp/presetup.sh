#!/bin/bash -xv

pip='pip3.9'
python='python3.9'
tceload='tce-load'
pythonpkg='python3.9'
zoommt='zoommon'
tmpdir="$HOME/tmp"
mkdir -p "$tmpdir"
export PYPPETEER_HOME="/usr/local/share/zoommon"
$tceload -w ntpclient
$tceload -w $pythonpkg
$tceload -w git
$tceload -w compiletc
$tceload -w ${pythonpkg}-dev 
$tceload -w squashfs-tools 
$tceload -w rsync 

$tceload -i ntpclient
$tceload -i $pythonpkg
$tceload -i git
$tceload -il compiletc
$tceload -il ${pythonpkg}-dev 
$tceload -il squashfs-tools 
$tceload -il rsync

if ! which $pipv
then
	$python -m ensurepip
	$python -m pip install  --upgrade pip
fi
/bin/rm -rf $tmpdir/pkg
mkdir -p $tmpdir/pkg
$python -m pip install playwright aiohttp[speedups] --ignore-installed --root=$tmpdir/pkg

( cd $tmpdir/pkg && find usr -type d -name __pycache__  | xargs rm -rf )
( cd $tmpdir/pkg && find usr -type f -name "*.py[co]" | xargs rm -f )
cd $tmpdir
rm -f ${pythonpkg}-extras.tcz	
sudo mksquashfs pkg/ ${pythonpkg}-extras.tcz
sudo chown tc:staff ${pythonpkg}-extras.tcz 
md5sum ${pythonpkg}-extras.tcz > ${pythonpkg}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${pythonpkg}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${pythonpkg}-extras.tcz.list
$tceload -i ./${pythonpkg}-extras.tcz

sudo /bin/rm -rf  "$PYPPETEER_HOME"
sudo mkdir -p "$PYPPETEER_HOME/pw-browsers"
sudo chown 777 "$PYPPETEER_HOME" "$PYPPETEER_HOME/pw-browsers"

export PLAYWRIGHT_BROWSERS_PATH "$PYPPETEER_HOME/pw-browsers"
$python -m playwright install
rsync --append-verify --inplace --remove-source-files --delete -lptAXH --force "$PYPPETEER_HOME" $tmpdir/pkg2 
rm -f ${zoommt}-extras.tcz	
sudo mksquashfs pkg2/ ${zoommt}-extras.tcz
sudo chown tc:staff ${zoommt}-extras.tcz 
md5sum ${zoommt}-extras.tcz > ${zoommt}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${zoommt}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${zoommt}-extras.tcz.list
$tceload -i ./${zoommt}-extras.tcz
