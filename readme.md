# Robot Framework Appium Automation for [Your App Name / com.todoorstep.store]

This repository contains automated mobile tests for the `[com.todoorstep.store]` Android application, built using Robot Framework and Appium.

## Overview

The primary goal of this project is to automate the testing of key user flows within the application, focusing on exploring product categories and lists as a guest user. It utilizes Appium for mobile interaction and Robot Framework for test case structure, execution, and reporting.

## Features Tested

*   **Guest Mode Entry:** Verifies the ability to enter the application without logging in.
*   **Category Exploration:**
    *   Navigates to the home screen displaying product categories.
    *   Iterates through a predefined list of categories.
    *   Scrolls down the home screen to find and click on each specific category.
*   **Product List Exploration:**
    *   After entering a category, waits for the product list page to load.
    *   Scrolls down the product list page incrementally.
    *   Captures screenshots of each visible portion of the product list during scrolling.
    *   Detects the end of the product list using page source comparison or specific end-of-list elements.
*   **Navigation:** Handles returning to the home screen after exploring a category.
*   **Reporting:** Generates detailed HTML logs and reports, including embedded screenshots for visual verification.

## Technology Stack

*   **Test Framework:** Robot Framework
*   **Mobile Automation:** Appium (v2.x recommended)
*   **Appium Driver:** UIAutomator2 (for Android)
*   **Core Library:** AppiumLibrary (Robot Framework)
*   **Language:** Python (for Robot Framework execution)
*   **Dependencies:** Appium-Python-Client (installed via `requirements.txt`)

## Prerequisites

Before you begin, ensure you have the following installed and configured on your system:

1.  **Python:** Version 3.8 or higher recommended.
2.  **pip:** Python package installer.
3.  **Node.js and npm:** Required for installing Appium.
4.  **Appium Server:** Install globally: `npm install -g appium`
5.  **Appium UIAutomator2 Driver:** Install via Appium: `appium driver install uiautomator2`
6.  **Java Development Kit (JDK):** Required by the Android SDK tools. Version 8, 11, or 17 are commonly used.
7.  **Android SDK:** Set up Android SDK with platform-tools (adb) and build-tools. Ensure `ANDROID_HOME` environment variable is set and `adb` is in your system's PATH.
8.  **Android Device/Emulator:** An active Android emulator or a physical device with USB Debugging enabled and recognized by `adb devices`.

## Setup

1.  **Clone the repository:**
    ```bash
    git clone [Your Repository URL]
    cd [Repository Folder Name] # e.g., cd Appium-Automation-Script-Development
    ```
2.  **Create and activate a virtual environment (recommended):**
    ```bash
    python -m venv venv
    # On Windows:
    .\venv\Scripts\activate
    # On macOS/Linux:
    source venv/bin/activate
    ```
3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```
    *(Note: Make sure your `requirements.txt` file includes at least `robotframework` and `robotframework-appiumlibrary`)*

## Configuration

Before running the tests, you need to configure the environment and application details in the `variables/config.robot` file:

1.  **Appium Server:** Ensure `${APPIUM_SERVER}` points to your running Appium instance (default is usually correct).
2.  **Device Details:**
    *   Set `${PLATFORM_NAME}` to `Android`.
    *   Update `${DEVICE_NAME}` with the UDID of your physical device or the name of your emulator (as shown by `adb devices`).
3.  **Application Details:**
    *   Update `${APP_PACKAGE}` to the correct package name of the application under test (e.g., `com.todoorstep.store`).
    *   Update `${APP_ACTIVITY}` to the main launchable activity (often `.MainActivity` or similar). Consult the app developer or use tools like `adb shell dumpsys window | grep -E 'mCurrentFocus|mFocusedApp'` if unsure.
    *   **IMPORTANT:** If the test needs to install the app, uncomment and set the `${APP_PATH}` variable to the *absolute path* of the `.apk` file on your machine. If the app is already installed, ensure `noReset=${true}` is set (or remove `${APP_PATH}`).
4.  **Categories:** Verify the list in `@{CATEGORIES}` and the mapping in `&{CATEGORY_FILENAME_MAP}` match the application exactly (including spelling and case).

## Running the Tests

1.  **Start the Appium Server:** Open a terminal window and run:
    ```bash
    appium
    ```
    Wait until it indicates it's listening (e.g., on port 4723).
2.  **Ensure Device/Emulator is Ready:** Make sure your target Android device or emulator is running, unlocked, and recognized by `adb devices`.
3.  **Run Robot Framework:** Open *another* terminal window, navigate to the project's root directory (`Appium-Automation-Script-Development`), activate your virtual environment (if using one), and run the tests:
    ```bash
    robot -d results tests/test.robot
    ```
    *   `-d results`: This flag directs Robot Framework to put all output files (log.html, report.html, output.xml, and the `screenshots` folder) into the `results` directory.

## Project Structure
Appium-Automation-Script-Development/
├── locators/ # .robot files defining UI element locators
│ ├── common_locators.robot
│ └── product_locators.robot
├── logs/ # Currently unused by the script output (might hold Appium server logs)
├── resources/ # Reusable keywords organized by feature/page
│ ├── common.robot
│ ├── guest_mode_actions.robot
│ ├── home_page_actions.robot
│ ├── product_list_actions.robot
│ └── logs.robot
├── results/ # Test execution output (logs, reports, screenshots) - Created by robot -d results
├── tests/ # Test suite files (.robot) containing test cases
│ └── test.robot
├── variables/ # Configuration variables (Appium capabilities, timeouts, data)
│ └── config.robot
├── readme.md # This file
└── requirements.txt # Python dependencies
## Viewing Results

After the test execution finishes:

1.  Navigate to the `results/` directory (created by the `robot -d results ...` command).
2.  Open `report.html` in your web browser for a high-level summary of test results.
3.  Open `log.html` for a detailed, step-by-step execution log, including logs generated by the script and embedded screenshots.
4.  Screenshots captured during the test run are organized into subfolders within `results/screenshots/`.

---

Remember to replace placeholders and adjust paths/commands based on your specific setup!