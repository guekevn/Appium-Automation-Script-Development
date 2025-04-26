*** Settings ***
Library    AppiumLibrary
Library    Collections
Resource    ../variables/config.robot
#Resource    ../locators/categories_locators.robot
Resource    ../locators/common_locators.robot
Resource    common.robot
Resource    logs.robot

*** Keywords ***
Find And Navigate To Category
    [Arguments]    ${category_name}

    ${safe_name}=    Get From Dictionary    ${CATEGORY_FILENAME_MAP}    ${category_name}
    Log Info    Optimized search: Finding category: ${category_name}

    ${index}=    Get Index From List    ${CATEGORIES}    ${category_name}
    ${category_index}=    Evaluate    ${index} + 1

    Log Info    Finding category: ${category_name} at index: ${category_index}

    # Buat dynamic locator
    ${category_locator}=    Set Variable    xpath=//android.widget.GridView[@resource-id="com.todoorstep.store:id/rvBanners"]/android.view.ViewGroup[${category_index}]/android.widget.ImageView

    Log Info    Using dynamic locator: ${category_locator}

    # Try scrolling to find the category
    ${max_scrolls}=    Set Variable    10
    ${found}=    Set Variable    ${FALSE}

    FOR    ${i}    IN RANGE    ${max_scrolls}
        ${is_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${category_locator}    timeout=2s 

        IF    ${is_visible}
            ${found}=    Set Variable    ${TRUE}
            Exit For Loop
        END

        # Scroll down to look for more categories
        Scroll Down Safely
        Sleep    0.5s 
    END

    Run Keyword If    not ${found}    Fail    Category '${category_name}' with locator '${category_locator}' not found after ${max_scrolls} scrolls

    # Take screenshot before clicking
    Log Activity And Take Screenshot    ${safe_name}_before_click    ${safe_name}

    # Click on the category using the specific locator
    Click Element    ${category_locator}
    Sleep    ${PAUSE_AFTER_CLICK}

    # Take screenshot after entering category
    Log Activity And Take Screenshot    ${safe_name}_after_click    ${safe_name}

    Log Info    Successfully navigated to ${category_name}

Return To Home
    Log Info    Returning to home page

    # Coba klik tombol Back aplikasi jika ada
    ${back_visible}=    Run Keyword And Return Status    Page Should Contain Element    ${BACK_BUTTON}  
    IF    ${back_visible}
        Click Element    ${BACK_BUTTON}
    ELSE
        ${home_visible}=    Run Keyword And Return Status    Page Should Contain Element    ${HOME_BUTTON} 
        IF    ${home_visible}
            Click Element    ${HOME_BUTTON}
        ELSE
            Log Info    App Back/Home button not found, using system Back keycode.
            Press Keycode    4 
        END
    END

    Sleep    2s 
    # Wait Until Page Contains Element    ${HOME_PAGE_INDICATOR}    timeout=10s
    Log Activity And Take Screenshot    returned_to_home    general

