/**
 * 
 */
var webdriver = require('selenium-webdriver');
var firefoxOptions = {'args':['--kiosk']};
var firefoxCapabilities = webdriver.Capabilities.firefox()
firefoxCapabilities.set('firefoxOptions',firefoxOptions);
var driver = new webdriver.Builder().
   withCapabilities(firefoxCapabilities).build();
 
driver.get('http://www.lambdatest.com');
driver.wait(async () => {
    const readyState = await driver.executeScript('return document.readyState');
    return readyState === 'complete';
  });
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

