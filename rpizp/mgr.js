/**
 * 
 */
var webdriver = require('selenium-webdriver');
var firefox = require('selenium-webdriver/firefox')
var options =  new firefox.Options();
options.addArguments('-kiosk');
var driver = new webdriver.Builder().forBrowser("firefox").setFirefoxOptions(options).build();
driver.wait(async () => {
    const readyState = await driver.executeScript('return document.readyState');
    return readyState === 'complete';
  });

driver.manage().window().maximize();
 
driver.get('http://www.lambdatest.com');
// driver.quit();

async function main() {
  await driver.get('https://developer.mozilla.org/');
  await driver.findElement(By.id('home-q')).sendKeys('testing', Key.RETURN);
  await driver.wait(until.titleIs('Search Results for "testing" | MDN'));
  await driver.wait(async () => {
    const readyState = await driver.executeScript('return document.readyState');
    return readyState === 'complete';
  });
  const data = await driver.takeScreenshot();
  await promisify(writeFile)('screenshot.png', data, 'base64');
  await driver.quit();
}

