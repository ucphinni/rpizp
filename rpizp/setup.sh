#!/bin/sh

tce-load -wi chromium-browser ntpclient python3.9
tce-load -wi compiletc python3.9-dev
python3.9 -m ensurepip
python3.9 -m pip install --upgrade pip
python3.9 -m pip freeze > oldrequirements.txt
python3.9 -m pip install pyppeteer aiohttp[speedups]
python3.9 -m pip freeze > newrequirements.txt
diff --changed-group-format='%<' --unchanged-group-format='' newrequirements.txt oldrequirements.txt > requirements.txt
python3.9 -m pip uninstall -y pyppeteer aiohttp[speedups]
python3.9 -m pip uninstall -y -r requirements.txt

tce-audit builddb
tce-audit delete compiletc python3.9-dev