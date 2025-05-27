# Mobile App Automation Project with Appium and Robot Framework

This project contains automation scripts for testing the [Your App Name or General App Description] mobile application using Appium and Robot Framework. The scripts are designed to explore product categories, sub-categories, and product pages, including handling tabs within product pages.

## Key Features

*   Navigation through parent and child categories.
*   Scrolling products under each category/sub-category.
*   Handling of sub-tabs on product list pages.
*   Utilizes Appium for interaction with mobile UI elements.
*   Modular project structure with separation of locators, keywords, and test cases.
*   Logging and screenshot capturing for debugging.
*   Tracking mechanism for processed categories (optional, if `processed_children_tracker.txt` is committed).

## Prerequisites

Before running these scripts, ensure you have the following installed and configured:

*   **Node.js and npm**: Required for Appium.
*   **Appium Server**: `npm install -g appium` (or Appium Desktop).
*   **Appium Doctor**: To verify your Appium installation: `npm install -g appium-doctor`.
*   **Java Development Kit (JDK)**: Required for the Android SDK.
*   **Android SDK**: With Android Debug Bridge (ADB) and a configured Android emulator/device.
*   **Python**: Version 3.x recommended.
*   **Robot Framework**: `pip install robotframework`
*   **AppiumLibrary for Robot Framework**: `pip install robotframework-appiumlibrary`
*   **Git**: For cloning the repository.
*   **UIAutomator2 Driver**: Appium usually installs this during the first session, or you can set it up manually.

Ensure environment variables like `ANDROID_HOME` and `JAVA_HOME` are set correctly.

## Project Setup

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/YOUR_USERNAME/YOUR_REPOSITORY_NAME.git
    cd YOUR_REPOSITORY_NAME
    ```

2.  **Install Python Dependencies (if a `requirements.txt` file is present)**:
    (You can create a `requirements.txt` file with `pip freeze > requirements.txt`)
    ```bash
    pip install -r requirements.txt
    ```

3.  **Configure Application and Device Details**:
    Edit the `resources/variables/config.resource` file to set:
    *   `APPIUM_SERVER`: Your Appium server URL (default: `http://127.0.0.1:4723`).
    *   `PLATFORM_NAME`: E.g., `Android`.
    *   `DEVICE_NAME`: Your emulator's name or physical device's UDID.
    *   `APP_PACKAGE`: The package name of the application under test.
    *   `APP_ACTIVITY`: The main launchable activity of the application under test.
    *   Other variables like category lists if they need adjustment.

## Project Structure
├── resources/
│ ├── keywords/ # Custom keyword files
│ ├── locators/ # UI element locator files
│ └── variables/ # Configuration variable files
├── test_suites/
│ └── test.robot # Main test case file(s)
├── .gitignore # Files ignored by Git
└── README.md # This file


## Running the Tests

1.  **Ensure the Appium Server is running.** You can start it from the terminal:
    ```bash
    appium
    ```
    Or run Appium Desktop.

2.  **Ensure an Android emulator is running or a physical device is connected** and recognized by ADB (`adb devices`).

3.  **Execute the Robot Framework tests** from the project's root directory:
    ```bash
    robot test_suites/test.robot
    ```
    Alternatively, to run tests with a specific tag:
    ```bash
    robot -i Smoke test_suites/test.robot
    ```

## Viewing Test Results

After execution, result files will be generated in the project root (or in `output_dir` if configured):
*   `output.xml`: Detailed XML output.
*   `log.html`: Interactive HTML log, very useful for debugging.
*   `report.html`: Summary test report.

Screenshots (if enabled and errors occur or for activity logging) will be saved in a `screenshots` subdirectory within your reports directory (e.g., `reports/screenshots/`).

## Contributing

If you'd like to contribute, please fork the repository and create a pull request.

## License

(Optional: Add license information if applicable, e.g., MIT, Apache 2.0, etc.)
