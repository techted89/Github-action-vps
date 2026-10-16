#!/usr/bin/env python3
import sys
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options

def initialize_stealth_driver() -> webdriver.Chrome:
    options = Options()
    options.add_argument("--headless=new")
    options.add_argument("--disable-gpu")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-blink-features=AutomationControlled")
    options.add_argument("user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36")
    options.add_experimental_option("excludeSwitches", ["enable-automation"])
    options.add_experimental_option("useAutomationExtension", False)
    service = Service()
    driver = webdriver.Chrome(service=service, options=options)
    driver.execute_cdp_cmd("Page.addScriptToEvaluateOnNewDocument", {
        "source": "Object.defineProperty(navigator, 'webdriver', { get: () => undefined });"
    })
    return driver

def main() -> None:
    target_url = sys.argv[1] if len(sys.argv) > 1 else "https://github.com/login"
    print(f"[+] Initializing stealth browser automation for target: {target_url}")
    driver = initialize_stealth_driver()
    try:
        driver.get(target_url)
        time.sleep(3)
        print(f"[+] Page title loaded successfully: {driver.title}")
    except Exception as e:
        print(f"[-] Error during stealth navigation: {e}", file=sys.stderr)
        sys.exit(1)
    finally:
        driver.quit()
        print("[✓] Browser session terminated safely.")

if __name__ == "__main__":
    main()
