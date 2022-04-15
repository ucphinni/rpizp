#!/bin/sh

tce-load -wi chromium-browser ntpclient python3.9
tce-load -wi comppiletc python3.9-dev
sudo python3.9 -m ensurepip
sudo python3.9 -m pip install --upgrade pip
python3.9 -m pip freeze > oldrequirements.txt
sudo python3.9 -m pip install pyppeteer aiohttp[speedups]
python3.9 -m pip freeze > newrequirements.txt
diff --changed-group-format='%<' --unchanged-group-format='' newrequirements.txt oldrequirements.txt > requirements.txt
sudo python3.9 -m pip uninstall pyppeteer aiohttp[speedups]

tce-audit builddb
tce-audit delete comppiletc python3.9-dev