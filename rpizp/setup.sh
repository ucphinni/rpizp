#!/bin/sh

python='python3.9'
tceload='tce-load'
tceaudit='tce-audit'

$tceload -wi chromium-browser ntpclient python3.9
$tceload -wi compiletc python3.9-dev
$python -m ensurepip
$python -m pip install --upgrade pip
$python -m pip freeze > oldrequirements.txt
$python -m pip install pyppeteer aiohttp[speedups]
$python -m pip freeze > newrequirements.txt
diff --changed-group-format='%<' --unchanged-group-format='' newrequirements.txt oldrequirements.txt > requirements.txt

$python -m pip uninstall -y pyppeteer aiohttp[speedups]
$python -m pip uninstall -y -r requirements.txt

$tceaudit builddb
$tceaudit delete compiletc
$tceaudit builddb
$tceaudit delete python3.9-dev