*** Settings ***
Library    AppiumLibrary
Library    Collections
Library    Process
Library    BuiltIn
Resource   ../variables/config.resource
Resource   logging_keywords.resource


*** Keywords ***
Start Test Session
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

End Test Session
    Log Info    Ending Test Session: Closing application...
    Run Keyword And Ignore Error    Close Application
    Log Info    Application closed command sent (or ignored if already closed).

Scroll Down Screen
    ${width_val}=    Get Window Width With Retry
    ${height_val}=   Get Window Height With Retry

    ${expr_start_x}=    Catenate    SEPARATOR=    ${width_val}    *    ${SCROLL_X_PERCENT}
    ${expr_start_y}=    Catenate    SEPARATOR=    ${height_val}   *    ${SCROLL_START_Y_PERCENT}
    ${expr_end_x}=      Catenate    SEPARATOR=    ${width_val}    *    ${SCROLL_X_PERCENT}
    ${expr_end_y}=      Catenate    SEPARATOR=    ${height_val}   *    ${SCROLL_END_Y_PERCENT}

    ${start_x}=    Evaluate    ${expr_start_x}
    ${start_y}=    Evaluate    ${expr_start_y}
    ${end_x}=      Evaluate    ${expr_end_x}
    ${end_y}=      Evaluate    ${expr_end_y}

    Log Debug    Swiping down from [${start_x}, ${start_y}] to [${end_x}, ${end_y}] duration ${SCROLL_DURATION_MS}ms
    TRY
        Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${SCROLL_DURATION_MS}
    EXCEPT    WebDriverException    type=glob    AS    ${error_message_str}
        Log Warn    Swipe action failed: ${error_message_str}. Trying mobile:scroll fallback.
        Run Keyword And Ignore Error    Execute Script    mobile: scroll    direction=down
    END
    Sleep    ${PAUSE_AFTER_SCROLL}

Scroll Down Screen Slightly
    ${width_val}=    Get Window Width With Retry
    ${height_val}=   Get Window Height With Retry

    ${expr_start_x}=    Catenate    SEPARATOR=    ${width_val}    *    ${SCROLL_X_PERCENT}
    ${expr_start_y}=    Catenate    SEPARATOR=    ${height_val}   *    ${SMALL_SCROLL_DOWN_START_Y}
    ${expr_end_x}=      Catenate    SEPARATOR=    ${width_val}    *    ${SCROLL_X_PERCENT}
    ${expr_end_y}=      Catenate    SEPARATOR=    ${height_val}   *    ${SMALL_SCROLL_DOWN_END_Y}

    ${start_x}=    Evaluate    ${expr_start_x}
    ${start_y}=    Evaluate    ${expr_start_y}
    ${end_x}=      Evaluate    ${expr_end_x}
    ${end_y}=      Evaluate    ${expr_end_y}

    Log Debug    Swiping slightly down from [${start_x}, ${start_y}] to [${end_x}, ${end_y}] duration ${SMALL_SCROLL_DURATION_MS}ms
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${SMALL_SCROLL_DURATION_MS}
    Sleep    1.0s

Scroll Up Screen Slightly 
    [Documentation]    Swipes screen content DOWN (finger moves from top to bottom slightly).
    ...                Effectively scrolls the viewable area UP a bit.
    ${width_val}=    Get Window Width With Retry
    ${height_val}=   Get Window Height With Retry

    ${start_x}=    Evaluate    ${width_val} * ${SCROLL_X_PERCENT}
    ${start_y}=    Evaluate    ${height_val} * 0.3     
    ${end_y}=      Evaluate    ${height_val} * 0.5     

    Log Debug    Swiping slightly to scroll content DOWN (view UP) from [${start_x}, ${start_y}] to [${start_x}, ${end_y}] duration ${SMALL_SCROLL_DURATION_MS}ms
    Swipe    ${start_x}    ${start_y}    ${start_x}    ${end_y}    ${SMALL_SCROLL_DURATION_MS}
    Sleep    1.0s

Custom Scroll Element Into View
    [Arguments]    ${locator}
    Log Debug    Attempting to scroll element ${locator} into view.
    TRY
        ${is_visible}=    Is Element Visible On Screen    ${locator}
        Return From Keyword If    ${is_visible}    

        ${location}=         AppiumLibrary.Get Element Location    ${locator}
        ${size}=             AppiumLibrary.Get Element Size       ${locator}
        ${screen_height_val}=    AppiumLibrary.Get Window Height
        ${screen_width_val}=     AppiumLibrary.Get Window Width

        ${element_center_y}=    Evaluate    ${location['y']} + (${size['height']} / 2)
        ${screen_center_y}=     Evaluate    ${screen_height_val} / 2

        IF    ${element_center_y} > ${screen_center_y}    
            ${sx}=    Evaluate    ${screen_width_val} / 2
            ${sy_start}=    Evaluate    ${screen_height_val} * 0.8     
            ${sy_end}=    Evaluate    ${screen_height_val} * 0.2       
            Swipe    ${sx}    ${sy_start}    ${sx}    ${sy_end}    500
            Log Debug    Scrolled content UP.
        ELSE IF    ${element_center_y} < ${screen_center_y}    
            ${sx}=    Evaluate    ${screen_width_val} / 2
            ${sy_start}=    Evaluate    ${screen_height_val} * 0.2     
            ${sy_end}=    Evaluate    ${screen_height_val} * 0.8       
            Swipe    ${sx}    ${sy_start}    ${sx}    ${sy_end}    500
            Log Debug    Scrolled content DOWN.
        END
        Sleep    0.5s
    EXCEPT    *    type=glob    AS    ${exception_message_string}
        Log Warn    Could not complete Custom Scroll Element Into View for ${locator}. Error: ${exception_message_string}
    END

Scroll Right On Element
    [Arguments]    ${target_element_locator_for_swipe}
    Log Info    Attempting to scroll right (swipe left) on element: ${target_element_locator_for_swipe}
    Wait Until Page Contains Element    ${target_element_locator_for_swipe}    timeout=5s    error=Target element for horizontal swipe not found: ${target_element_locator_for_swipe}

    ${location}=    Get Element Location With Retry    ${target_element_locator_for_swipe}
    ${size}=        Get Element Size With Retry      ${target_element_locator_for_swipe}

    ${start_x}=     Evaluate    ${location['x']} + (${size['width']} * 0.8)
    ${start_y}=     Evaluate    ${location['y']} + (${size['height']} / 2)
    ${end_x}=       Evaluate    ${location['x']} + (${size['width']} * 0.2)
    ${end_y}=      Set Variable    ${start_y}

    Log Debug    Swiping on element from [${start_x}, ${start_y}] to [${end_x}, ${end_y}]
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${SCROLL_DURATION_MS}
    Sleep    ${PAUSE_AFTER_SCROLL}

Scroll Left On Element
    [Arguments]    ${target_element_locator_for_swipe}
    Log Info    Attempting to scroll left (swipe right) on element: ${target_element_locator_for_swipe}
    Wait Until Page Contains Element    ${target_element_locator_for_swipe}    timeout=5s    error=Target element for horizontal swipe not found: ${target_element_locator_for_swipe}

    ${location}=    Get Element Location With Retry    ${target_element_locator_for_swipe}
    ${size}=        Get Element Size With Retry      ${target_element_locator_for_swipe}

    ${start_x}=     Evaluate    ${location['x']} + (${size['width']} * 0.2)
    ${start_y}=     Evaluate    ${location['y']} + (${size['height']} / 2)
    ${end_x}=       Evaluate    ${location['x']} + (${size['width']} * 0.8)
    ${end_y}=      Set Variable    ${start_y}

    Log Debug    Swiping on element from [${start_x}, ${start_y}] to [${end_x}, ${end_y}]
    Swipe    ${start_x}    ${start_y}    ${end_x}    ${end_y}    ${SCROLL_DURATION_MS}
    Sleep    ${PAUSE_AFTER_SCROLL}

Run Keyword And Retry On Connection Error
    [Arguments]    ${keyword_to_run}    @{args}    ${retries}=1
    FOR    ${attempt}    IN RANGE    ${retries} + 1
        TRY
            ${result}=    Run Keyword    ${keyword_to_run}    @{args}
            RETURN    ${result}
        EXCEPT    WebDriverException    type=glob    AS    ${exception_string}
            Log Warn    Connection error attempt ${attempt+1}/${retries+1} for '${keyword_to_run}': ${exception_string}
            IF    ${attempt} == ${retries}
                Fail    Keyword '${keyword_to_run}' failed after ${retries+1} attempts: ${exception_string}
            END
            Sleep    1s
        END
    END

Wait Until Element Is Visible With Retry
    [Arguments]    ${locator}    ${timeout}=${ELEMENT_WAIT_TIMEOUT}    ${error_message}=Element ${locator} not visible after timeout
    Run Keyword And Retry On Connection Error    Wait Until Element Is Visible    ${locator}    ${timeout}    ${error_message}

Click Element With Retry
    [Arguments]    ${locator}
    Wait Until Element Is Visible With Retry    ${locator}
    Run Keyword And Retry On Connection Error    Click Element    ${locator}
    Sleep    ${PAUSE_AFTER_CLICK}

Get Element Location With Retry
    [Arguments]    ${locator}
    ${location}=    Run Keyword And Retry On Connection Error    Get Element Location    ${locator}
    RETURN    ${location}

Get Element Size With Retry
    [Arguments]    ${locator}
    ${size}=    Run Keyword And Retry On Connection Error    Get Element Size    ${locator}
    RETURN    ${size}

Get Window Height With Retry
    ${height}=    Run Keyword And Retry On Connection Error    Get Window Height
    RETURN    ${height}

Get Window Width With Retry
    ${width}=    Run Keyword And Retry On Connection Error    Get Window Width
    RETURN    ${width}

Get Source With Retry
    ${source}=    Run Keyword And Retry On Connection Error    Get Source
    RETURN    ${source}

Page Should Contain Element With Retry
    [Arguments]    ${locator}    ${timeout}=${ELEMENT_WAIT_TIMEOUT}    ${message}=None
    ${error_msg}=    Set Variable If    '${message}' != 'None'    ${message}    Element '${locator}' not found after timeout.
    Run Keyword And Retry On Connection Error    Wait Until Page Contains Element    ${locator}    ${timeout}    ${error_msg}

Press Keycode With Retry
    [Arguments]    ${keycode}
    Run Keyword And Retry On Connection Error    Press Keycode    ${keycode}

Get WebElements With Retry
    [Arguments]    ${locator}
    ${elements}=    Run Keyword And Retry On Connection Error    Get Webelements    ${locator}
    RETURN    ${elements}

Get Text With Retry
    [Arguments]    ${locator_or_element}
    ${text}=    Run Keyword And Retry On Connection Error    Get Text    ${locator_or_element}
    RETURN    ${text}

Is Element Visible On Screen
    [Arguments]    ${locator}
    ${is_present}=    Run Keyword And Return Status    Page Should Contain Element    ${locator}    timeout=0.5s 
    IF    not ${is_present}
        Log Debug    Element ${locator} not present in DOM for visibility check.
        RETURN    ${False}
    END
    TRY
        ${location}=    AppiumLibrary.Get Element Location    ${locator}
        ${size}=        AppiumLibrary.Get Element Size      ${locator}
        ${screen_height_num}=     AppiumLibrary.Get Window Height

        ${element_top_y_num}=       Set Variable    ${location['y']}
        ${element_height_num}=      Set Variable    ${size['height']}

        Run Keyword If    ${element_height_num} <= 0    Log Debug    Element ${locator} has height ${element_height_num}. Not visible.
        Return From Keyword If    ${element_height_num} <= 0    ${False}
        Run Keyword If    ${location['x']} < -1000 or ${location['y']} < -1000    Log Debug    Element ${locator} has suspicious location ${location}. Not visible.
        Return From Keyword If    ${location['x']} < -1000 or ${location['y']} < -1000    ${False}


        ${element_bottom_y_num}=    Evaluate    ${element_top_y_num} + ${element_height_num}

        ${visible_screen_top_y}=     Convert To Integer    0
        ${visible_screen_bottom_y}=  Set Variable    ${screen_height_num}

        ${overlap_top}=       Evaluate    max(${visible_screen_top_y}, ${element_top_y_num})
        ${overlap_bottom}=    Evaluate    min(${visible_screen_bottom_y}, ${element_bottom_y_num})

        ${min_pixel_overlap_for_visibility}=    Convert To Integer    10

        IF    (${overlap_bottom} - ${overlap_top}) >= ${min_pixel_overlap_for_visibility}
            Log Debug    Element ${locator} IS considered visible on screen. Overlap: ${overlap_top}-${overlap_bottom} (Delta: ${overlap_bottom - ${overlap_top}} >= ${min_pixel_overlap_for_visibility})
            RETURN    ${True}
        ELSE
            Log Debug    Element ${locator} is NOT considered visible. TopY:${element_top_y_num},BottomY:${element_bottom_y_num},ScreenH:${screen_height_num}. Overlap: ${overlap_top}-${overlap_bottom} (Delta: ${overlap_bottom - ${overlap_top}} < ${min_pixel_overlap_for_visibility})
            RETURN    ${False}
        END
    EXCEPT
        Log Debug    Error in Is Element Visible On Screen for ${locator}. Assuming not visible.
        RETURN    ${False}
    END

Position Element Near Top Of Screen
    [Arguments]    ${locator}
    Log Info    Attempting to position element ${locator} near top of screen.
    ${max_attempts_val}=    Get Variable Value    ${MAX_POSITIONING_ATTEMPTS}    3
    ${max_attempts_num}=    Convert To Integer    ${max_attempts_val}
    ${target_y_percentage_num}=     Convert To Number    0.20
    ${tolerance_pixels_num}=        Convert To Integer    50
    ${min_y_for_scroll_down_percentage_num}=     Convert To Number    0.05
    ${acceptable_y_range_top_percentage}=        Convert To Number    0.10    
    ${acceptable_y_range_bottom_percentage}=     Convert To Number    0.40    

    FOR    ${attempt}    IN RANGE    ${max_attempts_num}
        Log Debug    Positioning attempt ${attempt + 1}/${max_attempts_num} for ${locator}

        ${is_in_dom}=    Run Keyword And Return Status    Page Should Contain Element    ${locator}    timeout=0.5s
        IF    not ${is_in_dom}
            Log Warn    Element ${locator} not in DOM. Cannot position. (Attempt ${attempt + 1})
            Continue For Loop    
        END

        TRY
            ${location}=             AppiumLibrary.Get Element Location    ${locator}
            ${size}=                 AppiumLibrary.Get Element Size      ${locator}
            ${screen_height_num}=    AppiumLibrary.Get Window Height
            ${screen_width_num}=     AppiumLibrary.Get Window Width
            ${element_top_y_num}=    Set Variable    ${location['y']}
            ${element_height_num}=   Set Variable    ${size['height']}
        EXCEPT
            Log Warn    Could not get location/size for ${locator} even if in DOM. (Attempt ${attempt + 1})
            Continue For Loop
        END

      
        ${acceptable_top_y_min_num}=     Evaluate    ${screen_height_num} * ${acceptable_y_range_top_percentage}
        ${acceptable_top_y_max_num}=     Evaluate    ${screen_height_num} * ${acceptable_y_range_bottom_percentage}

        IF    ${element_height_num} > 0 and $element_top_y_num >= $acceptable_top_y_min_num and $element_top_y_num <= $acceptable_top_y_max_num
            Log Info    Element ${locator} is already in an acceptable position (Y: ${element_top_y_num} between ${acceptable_top_y_min_num}-${acceptable_top_y_max_num}). No swipe needed for positioning.
            Exit For Loop    
        END

        ${desired_top_y_num}=       Evaluate    ${screen_height_num} * ${target_y_percentage_num}
        ${threshold_low_num}=       Evaluate    ${desired_top_y_num} + ${tolerance_pixels_num}
        ${threshold_high_num}=      Evaluate    ${desired_top_y_num} - ${tolerance_pixels_num}
        ${min_y_pixels_for_scroll_down_num}=     Evaluate    ${screen_height_num} * ${min_y_for_scroll_down_percentage_num}

        Log Debug    El. Y: ${element_top_y_num}, Desired Y: ${desired_top_y_num}, Acceptable Range: [${acceptable_top_y_min_num}-${acceptable_top_y_max_num}], Target Range for Swipe: [${threshold_high_num} - ${threshold_low_num}]

        IF    $element_top_y_num > $threshold_low_num
            Log Debug    Element too low (Y:${element_top_y_num} > ${threshold_low_num}). Scrolling content UP.
            ${start_x}=    Evaluate    ${screen_width_num} * 0.5
            ${start_y_swipe}=    Evaluate    ${screen_height_num} * 0.7
            ${end_y_swipe}=      Evaluate    ${screen_height_num} * 0.3
            Swipe    ${start_x}    ${start_y_swipe}    ${start_x}    ${end_y_swipe}    800
            Sleep    1.5s
        ELSE IF    $element_top_y_num < $threshold_high_num and $element_top_y_num > $min_y_pixels_for_scroll_down_num
            Log Debug    Element too high (Y:${element_top_y_num} < ${threshold_high_num}), but not at very top. Scrolling content DOWN.
            ${start_x}=    Evaluate    ${screen_width_num} * 0.5
            ${start_y_swipe}=    Evaluate    ${screen_height_num} * 0.3
            ${end_y_swipe}=      Evaluate    ${screen_height_num} * 0.7
            Swipe    ${start_x}    ${start_y_swipe}    ${start_x}    ${end_y_swipe}    800
            Sleep    1.5s
        ELSE
            Log Info    Element ${locator} (Y:${element_top_y_num}) is within swipe tolerance or no swipe condition met.
        END

        Run Keyword If    ${attempt} == (${max_attempts_num} - 1)    Log Warn    Max positioning attempts (${max_attempts_num}) reached for ${locator}. Final Y: ${element_top_y_num}
    END
    Sleep    0.5s    