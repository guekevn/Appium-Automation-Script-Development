*** Settings ***
Library    AppiumLibrary
Library    DateTime
Library    String
Library    OperatingSystem
Library    Collections
Resource    ../variables/config.robot
Resource    logs.robot

*** Keywords ***
Start Test Session
    [Documentation]    Opens the application.
    Log Info    Starting Test Session: Opening application...
    Open Application    ${APPIUM_SERVER}
    ...    platformName=${PLATFORM_NAME}
    ...    deviceName=${DEVICE_NAME}
    ...    automationName=${AUTOMATION_NAME}
    ...    appPackage=${APP_PACKAGE}
    ...    appActivity=${APP_ACTIVITY}
    ...    noReset=${NO_RESET}   
    ...    uiautomator2ServerLaunchTimeout=90000 

    Log Info    Application opened successfully.
    Set Appium Timeout    ${IMPLICIT_WAIT_TIMEOUT}
    Log Info    Implicit wait set to ${IMPLICIT_WAIT_TIMEOUT}.

Scroll Down Safely
    [Documentation]    Performs a scroll down action using relative screen dimensions

    ${width}=    Get Window Width
    ${height}=    Get Window Height

    ${start_x}=    Evaluate    ${width} * 0.5
    ${start_y}=    Evaluate    ${height} * 0.8 
    ${end_x}=    Evaluate    ${width} * 0.5
    ${end_y}=    Evaluate    ${height} * 0.2    

    ${status}=    Run Keyword And Return Status    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    500 

    Run Keyword If    not ${status}    Execute Script    mobile: scroll    {"direction": "down"}

    Sleep    1s 

End Test Session
    [Documentation]    Closes the application session.
    Log Info    Ending Test Session: Closing application...
    Close Application
    Log Info    Application closed.