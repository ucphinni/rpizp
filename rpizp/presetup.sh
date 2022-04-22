#!/bin/bash -xv

tceload='tce-load'
nodepkg='node'
zoommt='zoommon'
tmpdir="$HOME/tmp"
mkdir -p "$tmpdir"
export PYPPETEER_HOME="/usr/local/share/vmtmon"
$tceload -w firefox-getLatest
$tceload -w ntpclient
$tceload -w node
$tceload -w git
$tceload -w squashfs-tools 
$tceload -w rsync 

$tceload -i firefox-getLatest
$tceload -i ntpclient
$tceload -i node
$tceload -i git
$tceload -il squashfs-tools 
$tceload -il rsync

sudo /bin/rm -rf  "$PYPPETEER_HOME"
sudo chown 777 "$PYPPETEER_HOME"
cd "PYPPETEER_HOME"
npm i selenium-webdriver
npm i geckodriver


rsync --append-verify --inplace --remove-source-files --delete -lptAXH --force "$PYPPETEER_HOME" $tmpdir/pkg2 
rm -f ${zoommt}-extras.tcz	
sudo mksquashfs pkg/ ${zoommt}-extras.tcz
sudo chown tc:staff ${zoommt}-extras.tcz 
md5sum ${zoommt}-extras.tcz > ${zoommt}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${zoommt}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${zoommt}-extras.tcz.list
$tceload -i ./${zoommt}-extras.tcz
