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
firefox-getLatest.sh -e > /dev/null
export PUPPETEER_HOME=/usr/local/share/puppeteer
sudo mkdir -p "$PUPPETEER_HOME"
sudo chmod 777 "$PUPPETEER_HOME"
( cd "$PUPPETEER_HOME" && npm install puppeteer )

mkdir -p $tmpdir/pkg$PUPPETEER_HOME
tar c -f - -C "$PUPPETEER_HOME" .  | tar x -f - --numeric-owner -C "$tmpdir/pkg"

sudo mksquashfs pkg/ ${nodepkg}-extras.tcz
sudo chown tc:staff ${nodepkg}-extras.tcz 
md5sum ${nodepkg}-extras.tcz > ${nodepkg}-extras.tcz.md5.txt
unsquashfs -ll -d '' ${nodepkg}-extras.tcz | grep -v '^d' | sed -e 's#.* /#/#' -e 's# -> .*##' -e 1,3d > ${nodepkg}-extras.tcz.list
$tceload -i ./${nodepkg}-extras.tcz
echo "${nodepkg}.tcz" > ${nodepkg}-extras.tcz.dep
cp ./${nodepkg}-extras.tcz ${nodepkg}-extras.tcz.md5.txt ${nodepkg}-extras.tcz.dep $tcedir/optional
