#!/usr/local/bin/python3

import asyncio
import re
from pyppeteer


def get_url_from_file(urlnum: int):
    with open("zmeet.url") as fp:
        Lines = fp.readlines()
        i = 0
        for line in Lines:
            g = re.search(r'^\s*([^:]*)\s*:\s*(.*)\s*$', line)
            if g is not None:
                i += 1
                if i == urlnum:
                    return g.group(2)
    return None


async def main():
    await launch_browser()
EXTENSION_PATH = 'chromium_ext'


async def launch_browser():
    urlnum = 1
    url = get_url_from_file(urlnum)
    if url is None:
        raise ValueError(f"Bad url num passed {urlnum}")
    browser = await pyppeteer.launch(
        args=['--start-maximized'],
        headless=False, executablePath='/usr/bin/chromium')
    page = await browser.newPage()
    print(f"going to page {url}")
    await page.goto(url, waitUtil='domcontentloaded',
                    timeout=99999999990000)
    # type 'Stage ParticipantList'
    print("inputing name")
    await page.type('#inputname', 'Stage ParticipantList')
    print("clicking join")
    # submit #id =joinBtn
    await page.click('[id="joinBtn"]')
    print("waiting for nav")
    await page.waitForNavigation()

    # wait for class meeting-app
    # wait until 'domcontentloaded'
    # find button with parent feature-type="participants"
    # click button
    # await browser.close()
asyncio.new_event_loop().run_until_complete(main())
