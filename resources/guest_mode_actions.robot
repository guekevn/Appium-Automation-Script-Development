*** Settings ***
Library    AppiumLibrary
Resource    ../variables/config.robot
Resource    ../locators/common_locators.robot
Resource    common.robot
Resource    logs.robot

*** Keywords ***
Enter Guest Mode
    [Documentation]    Enters the app as a guest user
    Log Info    Entering Guest Mode
    
    # Wait for the Guest Mode button and click it
    Wait Until Element Is Visible    ${GUEST_MODE_BUTTON}    ${ELEMENT_WAIT_TIMEOUT}
    Log Activity And Take Screenshot    before_guest_mode_click    navigation
    
    Click Element    ${GUEST_MODE_BUTTON}
    Sleep    ${PAUSE_AFTER_CLICK}
    
    Log Info    Waiting for Home Page indicator...
    Wait Until Element Is Visible    ${HOME_PAGE_INDICATOR}    timeout=20s 

    Log Activity And Take Screenshot    after_guest_mode_home_loaded    navigation
    Log Info    Successfully entered Guest Mode and Home Page is visible.