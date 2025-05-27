*** Settings ***
Library    AppiumLibrary
Resource   ../variables/config.resource
Resource   ../locators/common_locators.resource
Resource   common_keywords.resource
Resource   logging_keywords.resource

*** Keywords ***
Enter Guest Mode
    Log Info    Entering Guest Mode...
    Wait Until Element Is Visible With Retry    ${GUEST_MODE_BUTTON}
    Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot    before_guest_mode_click    navigation
    Click Element With Retry    ${GUEST_MODE_BUTTON}
    Log Info    Waiting for Home Page indicator after clicking Guest Mode...
    Wait Until Element Is Visible With Retry    ${HOME_PAGE_INDICATOR}    timeout=20s
    Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot    after_guest_mode_home_loaded    navigation
    Log Info    Successfully entered Guest Mode and Home Page is visible.