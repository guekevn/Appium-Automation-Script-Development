*** Settings ***
Library         AppiumLibrary
Library         BuiltIn
Library         Collections
Resource        ../variables/config.resource
Resource        ../locators/common_locators.resource
Resource        common_keywords.resource
Resource        logging_keywords.resource

*** Keywords ***
Navigate To Categories Tab
    Log Info    Navigating to Categories tab...
    Click Element With Retry    ${NAV_CATEGORIES_TAB}
    Wait Until Page Contains Element    ${CATEGORIES_PAGE_TOOLBAR_TITLE}    timeout=${ELEMENT_WAIT_TIMEOUT}
    Log Info    Successfully on Categories page.

Scroll To Top Of Categories Page
    [Documentation]    Attempts to scroll to the very top of the categories page.
    Log Info    Attempting to scroll to the top of Categories page.
    FOR    ${i}    IN RANGE    10
        ${source_before}=    Get Source With Retry
        Scroll Up Screen Slightly
        Sleep    0.5s
        ${source_after}=    Get Source With Retry
        Exit For Loop If    $source_after == $source_before
    END
    Sleep    1s

Check Parent And Child Visibility And Position
    [Arguments]    ${parent_locator}    ${child_container_locator}    ${parent_name_for_log}
    [Documentation]    Helper to check if parent is in DOM, position it, and then check
    ...                if both parent and child container are visible on screen.
    ...                Returns ${True} if optimal, ${False} otherwise.

    ${is_parent_in_dom}=    Run Keyword And Return Status    Page Should Contain Element    ${parent_locator}    timeout=1s
    IF    not ${is_parent_in_dom}
        Log Debug    [Helper] Parent "${parent_name_for_log}" not in DOM.
        RETURN    ${False}
    END

    Log Debug    [Helper] Parent "${parent_name_for_log}" in DOM. Attempting to position.
    Position Element Near Top Of Screen    ${parent_locator}
    Sleep    1.5s     

    ${is_parent_visible}=    Is Element Visible On Screen    ${parent_locator}
    Log Debug    [Helper] Parent "${parent_name_for_log}" visible on screen after pos? ${is_parent_visible}
    IF    not ${is_parent_visible}
        Log Warn    [Helper] Parent "${parent_name_for_log}" positioned but NOT visible.
        RETURN    ${False}
    END

    ${is_child_container_visible}=    Is Element Visible On Screen    ${child_container_locator}
    Log Debug    [Helper] Child container for "${parent_name_for_log}" visible on screen after pos? ${is_child_container_visible}
    IF    ${is_child_container_visible}
        Log Info    [Helper] SUCCESS: Parent "${parent_name_for_log}" and child container are visible.
        RETURN    ${True}
    END

    Log Warn    [Helper] Parent "${parent_name_for_log}" visible, but its child container is NOT.
    
    Log Info    [Helper] Attempting a slight scroll down to reveal child container for "${parent_name_for_log}".
    Scroll Down Screen Slightly
    Sleep    1.0s
    ${is_child_container_visible_after_slight_scroll}=    Is Element Visible On Screen    ${child_container_locator}
    IF    ${is_child_container_visible_after_slight_scroll}
        Log Info    [Helper] SUCCESS: Child container for "${parent_name_for_log}" now visible after slight scroll down.
        RETURN    ${True}
    END
    Log Warn    [Helper] Child container for "${parent_name_for_log}" still not visible after slight scroll.
    RETURN    ${False}

Scroll Vertically Until Parent And Child Container Are Optimal
    [Arguments]    ${parent_name_arg}
    Log Info    Starting search for parent "${parent_name_arg}" and its child container.

    Set Test Variable    ${text_to_find}    ${parent_name_arg}
    ${parent_locator_str}=    Replace Variables    ${PARENT_CATEGORY_TEXT_TEMPLATE}
    Log Info    [SVUCAPAO] Parent Locator for "${parent_name_arg}": ${parent_locator_str}

    Set Test Variable    ${parent_text_placeholder}    ${parent_name_arg}
    ${child_container_locator_str}=    Replace Variables    ${CHILD_HORIZONTAL_LIST_CONTAINER_AFTER_PARENT_TEMPLATE}
    Log Info    [SVUCAPAO] Child Container Locator for "${parent_name_arg}": ${child_container_locator_str}

    ${max_scroll_attempts_str}=     Get Variable Value    ${MAX_PAGE_SCROLLS}    "15"
    ${max_scroll_attempts}=     Convert To Integer    ${max_scroll_attempts_str}
    ${stall_threshold_str}=     Get Variable Value    ${CATEGORY_PAGE_SOURCE_STALL_THRESHOLD}    "3"
    ${stall_threshold_num}=     Convert To Integer    ${stall_threshold_str}

    Log Info    Phase 1: Initial check for "${parent_name_arg}" on current screen.
    ${optimal_on_initial_check}=    Check Parent And Child Visibility And Position
    ...    ${parent_locator_str}
    ...    ${child_container_locator_str}
    ...    ${parent_name_arg}
    IF    ${optimal_on_initial_check}
        Log Info    [SVUCAPAO] SUCCESS on Phase 1 for "${parent_name_arg}".
        Return From Keyword
    END

    Log Info    Phase 2: "${parent_name_arg}" not optimal on initial screen. Starting major scroll loop.
    ${stall_count_num}=         Set Variable    ${0}
    ${previous_page_source}=    Get Source With Retry

    FOR    ${scroll_attempt}    IN RANGE    ${max_scroll_attempts}
        Log Info    Major scroll attempt ${scroll_attempt + 1}/${max_scroll_attempts} for parent "${parent_name_arg}". Stall: ${stall_count_num}/${stall_threshold_num}.
        Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot    ${parent_name_arg}_major_scroll_attempt_${scroll_attempt}    categories_debug

        Scroll Down Screen
        Sleep    1.5s

        ${optimal_after_major_scroll}=    Check Parent And Child Visibility And Position
        ...    ${parent_locator_str}
        ...    ${child_container_locator_str}
        ...    ${parent_name_arg}
        IF    ${optimal_after_major_scroll}
            Log Info    [SVUCAPAO] SUCCESS on Phase 2, attempt ${scroll_attempt + 1} for "${parent_name_arg}".
            Return From Keyword
        END

        ${current_page_source}=    Get Source With Retry
        IF    $current_page_source == $previous_page_source
            ${stall_count_num}=    Evaluate    ${stall_count_num} + 1
            Log Warn    Category page source is SAME after major scroll. Stall: ${stall_count_num}/${stall_threshold_num}.
            IF    $stall_count_num >= $stall_threshold_num
                Log Warn    Category page source stalled for ${stall_threshold_num} attempts. Final check for "${parent_name_arg}".
                ${optimal_on_stall_check}=    Check Parent And Child Visibility And Position
                ...    ${parent_locator_str}
                ...    ${child_container_locator_str}
                ...    ${parent_name_arg}
                IF    ${optimal_on_stall_check}
                    Log Info    [SVUCAPAO] SUCCESS on stall check for "${parent_name_arg}".
                    Return From Keyword
                END
                Fail    Parent Category "${parent_name_arg}" not found or could not be optimally positioned (page source stalled and final check failed after stall).
            END
        ELSE
            ${stall_count_num}=    Set Variable    ${0}
        END
        ${previous_page_source}=    Set Variable    ${current_page_source}
    END

    Fail    Parent Category "${parent_name_arg}" not found or could not be optimally positioned within ${max_scroll_attempts} attempts (major scroll loop completed).


Find And Click Specific Child In Visible Container
    [Arguments]    ${parent_name_arg}    ${child_name_to_find_arg}
    Log Info    [FCC START] Finding "${child_name_to_find_arg}" under PARENT: "${parent_name_arg}".

    Set Test Variable    ${parent_text_placeholder}    ${parent_name_arg}
    
    ${any_view_container_after_parent_xpath}=    Replace Variables
    ...    xpath=//android.widget.TextView[@text="\${parent_text_placeholder}"]/following-sibling::android.view.View[1]
    Log Info    [FCC] Constructed ANY View Container XPath for "${parent_name_arg}": ${any_view_container_after_parent_xpath}

    Set Test Variable    ${text_to_find}    ${parent_name_arg}
    ${parent_locator_for_context_check}=    Replace Variables    ${PARENT_CATEGORY_TEXT_TEMPLATE}
    Log Debug   [FCC] Constructed Parent Locator for Context Check: ${parent_locator_for_context_check}

    ${is_parent_still_optimal}=    Check Parent And Child Visibility And Position
    ...    ${parent_locator_for_context_check}
    ...    ${any_view_container_after_parent_xpath} 
    ...    ${parent_name_arg}
    IF    not ${is_parent_still_optimal}
        Fail    Context lost: Parent "${parent_name_arg}" or its general view container ("${any_view_container_after_parent_xpath}") is no longer optimal before finding child.
    END

    Wait Until Page Contains Element    ${any_view_container_after_parent_xpath}    timeout=10s
    ...    error=General View container for "${parent_name_arg}" (XPath: ${any_view_container_after_parent_xpath}) not found.
    Log Info    [FCC] Successfully waited for General View Container: ${any_view_container_after_parent_xpath}
    Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot    ${parent_name_arg}_FCC_general_container_validated    categories_debug

    ${specific_child_xpath_in_this_container}=    Catenate    SEPARATOR=
    ...    ${any_view_container_after_parent_xpath}
    ...    //android.widget.TextView[@text="${child_name_to_find_arg}"]
    Log Info    [FCC] Attempting to find child DIRECTLY with XPath: ${specific_child_xpath_in_this_container}

    ${is_child_in_dom_direct}=    Run Keyword And Return Status    Page Should Contain Element    ${specific_child_xpath_in_this_container}    timeout=1s
    IF    ${is_child_in_dom_direct}
        ${is_visible_direct}=    Is Element Visible On Screen    ${specific_child_xpath_in_this_container}
        IF    ${is_visible_direct}
            Log Info    [FCC] Child "${child_name_to_find_arg}" found DIRECTLY and is VISIBLE. Clicking.
            Click Element With Retry    ${specific_child_xpath_in_this_container}
            Return From Keyword 
        END
    END
    Log Info    [FCC] Child "${child_name_to_find_arg}" not found directly or not visible in the general container. Proceeding to check for scrollable container.

    Set Test Variable    ${parent_text_placeholder_scrollable}    ${parent_name_arg}
    ${scrollable_horizontal_container_xpath}=    Replace Variables    ${CHILD_HORIZONTAL_LIST_CONTAINER_AFTER_PARENT_TEMPLATE} 
    Log Info    [FCC] Checking for SCROLLABLE container using XPath: ${scrollable_horizontal_container_xpath}

    ${is_scrollable_container_present}=    Run Keyword And Return Status    Page Should Contain Element    ${scrollable_horizontal_container_xpath}    timeout=1s
    IF    not ${is_scrollable_container_present}
        Log Warn    [FCC] NO SCROLLABLE horizontal container found for "${parent_name_arg}" using template. Cannot perform horizontal scroll.
        Fail    Child category "${child_name_to_find_arg}" not found (no direct match and no scrollable container to search in).
    END
    Log Info    [FCC] SCROLLABLE container found: ${scrollable_horizontal_container_xpath}. Starting H-Scroll loop.

    ${child_found_and_clicked}=    Set Variable    ${False}
    ${max_h_scrolls_str}=    Get Variable Value    ${MAX_HORIZONTAL_CHILD_SCROLLS}    "10"
    ${max_h_scrolls}=       Convert To Integer  ${max_h_scrolls_str}
    ${all_textviews_in_scrollable_container_xpath}=    Catenate    SEPARATOR=    ${scrollable_horizontal_container_xpath}    //android.widget.TextView

    FOR    ${h_scroll_attempt}    IN RANGE    ${max_h_scrolls}
        Log To Console    \n.
        Log Info    [FCC H-SCROLL ATTEMPT ${h_scroll_attempt + 1}/${max_h_scrolls}] (in scrollable) For "${child_name_to_find_arg}" under "${parent_name_arg}".
        Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot    ${parent_name_arg}_FCC_h_scroll_att_${h_scroll_attempt}    categories_debug
        TRY
            @{visible_child_elements_in_container}=    Get WebElements With Retry    ${all_textviews_in_scrollable_container_xpath}
        EXCEPT    *    AS    ${err_msg}
            Log Warn    [FCC H-SCROLL ${h_scroll_attempt + 1}] Error getting WebElements from SCROLLABLE container: ${err_msg}
            @{visible_child_elements_in_container}=    Create List
        END
        Log Info    [FCC H-SCROLL ${h_scroll_attempt + 1}] Found ${visible_child_elements_in_container.__len__()} TextView elements in SCROLLABLE container.
        Run Keyword If    ${visible_child_elements_in_container.__len__()} == 0
        ...    Log Warn    [FCC H-SCROLL ${h_scroll_attempt + 1}] NO TextViews found in SCROLLABLE container. XPath: ${all_textviews_in_scrollable_container_xpath}
        
        @{found_texts_in_container}=    Create List
        FOR    ${element}    IN    @{visible_child_elements_in_container}
            TRY
                ${text}=    Get Text    ${element}
                ${is_displayed}=    Call Method    ${element}    is_displayed
                Append To List    ${found_texts_in_container}    ${text} (Displayed: ${is_displayed})
            EXCEPT
                Append To List    ${found_texts_in_container}    [ERROR_GETTING_TEXT_OR_DISPLAYED_STATUS]
            END
        END
        Log Info    [FCC H-SCROLL ${h_scroll_attempt + 1}] Texts in SCROLLABLE child container: [ @{found_texts_in_container} ]

        ${specific_child_xpath_in_scrollable_container}=    Catenate    SEPARATOR=
        ...    ${scrollable_horizontal_container_xpath}
        ...    //android.widget.TextView[@text="${child_name_to_find_arg}"]
        Log Debug    [FCC H-SCROLL ${h_scroll_attempt + 1}] Exact child XPath in SCROLLABLE: ${specific_child_xpath_in_scrollable_container}
        ${is_child_in_dom}=    Run Keyword And Return Status
        ...    Page Should Contain Element    ${specific_child_xpath_in_scrollable_container}    timeout=0.2s
        IF    ${is_child_in_dom}
            Log Info    [FCC H-SCROLL ${h_scroll_attempt + 1}] Child "${child_name_to_find_arg}" IS IN DOM (scrollable). Checking visibility.
            ${is_truly_visible_on_screen}=   Is Element Visible On Screen    ${specific_child_xpath_in_scrollable_container}
            IF  ${is_truly_visible_on_screen}
                Log Info    [FCC H-SCROLL ${h_scroll_attempt + 1}] Child "${child_name_to_find_arg}" IS VISIBLE ON SCREEN (scrollable). Clicking.
                Click Element With Retry    ${specific_child_xpath_in_scrollable_container}
                ${child_found_and_clicked}=    Set Variable    ${True}
                Exit For Loop
            ELSE
                Log Warn    [FCC H-SCROLL ${h_scroll_attempt + 1}] Child "${child_name_to_find_arg}" in DOM but NOT VISIBLE ON SCREEN (scrollable).
            END
        ELSE
            Log Debug    [FCC H-SCROLL ${h_scroll_attempt + 1}] Child "${child_name_to_find_arg}" NOT in DOM in current view (scrollable).
        END

        IF    $h_scroll_attempt < ($max_h_scrolls - 1) and not $child_found_and_clicked
            Log Debug    [FCC H-SCROLL ${h_scroll_attempt + 1}] Child not found/clicked (scrollable). Scrolling right on: ${scrollable_horizontal_container_xpath}
            Scroll Right On Element    ${scrollable_horizontal_container_xpath}
            Sleep    1.5s
        END
    END

    Run Keyword If    not ${child_found_and_clicked}
    ...    Fail    Child category "${child_name_to_find_arg}" not found or could not be clicked under parent "${parent_name_arg}" after attempts.