#!/bin/bash -xv

tceload='tce-load'
nodepkg='node'
tcedir='/mnt/sda1/tce'
tmpdir="$HOME/tmp"
mkdir -p $tmpdir

$tceload -w ntpclient
$tceload -w firefox_getLatest
$tceload -w node
$tceload -w git
$tceload -w squashfs-tools 
$tceload -w compiletc
$tceload -w squashfs-tools 
$tceload -i ntpclient
$tceload -i firefox_getLatest
$tceload -i node
$tceload -i git
$tceload -i squashfs-tools 
$tceload -il compiletc
$tceload -il squashfs-tools 

/bin/rm -rf $tmpdir/pkg
mkdir -p "$tmpdir/pkg"

cd "$tmpdir"

export PYPPETEER_HOME=/usr/local/share/pyppeteer
sudo mkdir -p "$PYPPETEER_HOME"
sudo chmod 777 "$PYPPETEER_HOME"
/usr/local/bin/pyppeteer-install
mkdir -p $tmpdir/pkg$PYPPETEER_HOME
tar c -f - -C "$PYPPETEER_HOME" .  | tar x -f - --numeric-owner -C "$tmpdir/pkg"

sudo mksquashfs pkg/ ${nodepkg}-extras.tcz
sudo chown tc:staff ${nodepkg}-extras.tcz 
md5sum ${nodepkg}-extras.tcz > ${nodepkg}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${nodepkg}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${nodepkg}-extras.tcz.list
$tceload -i ./${nodepkg}-extras.tcz
echo "${nodepkg}.tcz" > ${nodepkg}-extras.tcz.dep
cp ./${nodepkg}-extras.tcz ${nodepkg}-extras.tcz.md5.txt ${nodepkg}-extras.tcz.dep $tcedir/optional
