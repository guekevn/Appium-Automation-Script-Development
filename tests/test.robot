*** Settings ***
Documentation    Test suite for exploring all product categories from guest mode
Library     AppiumLibrary
Resource    ../resources/common.robot
Resource    ../resources/guest_mode_actions.robot
Resource    ../resources/homepage_actions.robot
Resource    ../resources/logs.robot
Resource    ../variables/config.robot
#Resource    ../locators/categories_locators.robot
Resource    ../resources/products_actions.robot
Resource    ../locators/common_locators.robot

Suite Setup     Initialize Logging
Test Setup      Start Test Session  
Test Teardown   End Test Session

*** Test Cases ***
Explore All Categories From Guest Mode
    [Documentation]    Logs in as guest, explores categories, etc.
    
    Open Application    ${APPIUM_SERVER}    platformName=${PLATFORM_NAME}    deviceName=${DEVICE_NAME}    automationName=${AUTOMATION_NAME} 
    
    # Enter guest mode
    Enter Guest Mode
    
    # For each category
    FOR    ${category}    IN    @{CATEGORIES}
        Log Info    === Starting exploration of category: ${category} ===
        
        # Find and navigate to the category
        Find And Navigate To Category       ${category}
        
        # Explore products list with scrolling and screenshots
        Explore And Capture Product List    ${category}    
        
        # Return to home/categories page
        Return To Home
        
        Log Info    === Completed exploration of category: ${category} ===

    END
    
    Log Info    Exploration of all categories completed
    Close Application

