*** Settings ***
Library         AppiumLibrary
Library         Collections
Library         OperatingSystem
Library         String
Library         BuiltIn
Resource        ../variables/config.resource
Resource        ../locators/common_locators.resource     
Resource        common_keywords.resource
Resource        logging_keywords.resource
Resource        ../keywords/tracking_keywords.resource

*** Keywords ***
Scroll Products Under Current Tab
    [Documentation]    Scrolls products under the currently active tab/page.
    ...                Assumes navigation to the product list/tab is already done.
    [Arguments]    ${parent_child_identifier_for_log}    

    Log Info    Starting product scroll for: ${parent_child_identifier_for_log}
    ${source_before_main_loop}=    Get Source With Retry
    ${initial_source_changed}=      Set Variable    ${False}

    FOR    ${attempt}    IN RANGE    ${MAX_INITIAL_PRODUCT_SCROLLS}
        Scroll Down Screen Slightly
        Sleep    0.5s    
        ${source_after_initial}=    Get Source With Retry
        IF    $source_after_initial != $source_before_main_loop
            Log Info    Initial page source changed after ${attempt + 1} scroll(s) for ${parent_child_identifier_for_log}.
            ${source_before_main_loop}=    Set Variable    ${source_after_initial}
            ${initial_source_changed}=    Set Variable    ${True}
            Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot    ${parent_child_identifier_for_log}_initial_scroll_changed    ${parent_child_identifier_for_log}
            Exit For Loop
        END
        Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot    ${parent_child_identifier_for_log}_initial_scroll_${attempt}    ${parent_child_identifier_for_log}
    END
    IF    not ${initial_source_changed}
        Log Warn    Initial page source did not change significantly after ${MAX_INITIAL_PRODUCT_SCROLLS} scrolls for ${parent_child_identifier_for_log}.
    END

    ${reached_end}=      Set Variable    ${False}
    ${stall_count}=      Set Variable    0
    FOR    ${i}    IN RANGE    ${PRODUCT_EXPLORE_DEPTH}    
        Exit For Loop If    ${reached_end}

        Scroll Down Screen    
        Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot    ${parent_child_identifier_for_log}_scrolled_main_${i}    ${parent_child_identifier_for_log}

        ${found_footer}=    Run Keyword And Return Status    Page Should Contain Element With Retry    ${NO_MORE_PRODUCTS_TEXT}    timeout=0.5s
        IF    ${found_footer}
            Log Info    [End Detect] Found footer text for ${parent_child_identifier_for_log}.
            ${is_footer_visible}=   Is Element Visible On Screen    ${NO_MORE_PRODUCTS_TEXT}
            IF  ${is_footer_visible}
                Log Info    [End Detect] Footer text is VISIBLE for ${parent_child_identifier_for_log}. Assuming end of list.
                ${reached_end}=    Set Variable    ${TRUE}
                CONTINUE    
            ELSE
                Log Debug   Footer text in DOM but not visible, continue scrolling for ${parent_child_identifier_for_log}.
            END
        END

        ${source_after_main_scroll}=     Get Source With Retry
        IF    $source_after_main_scroll == $source_before_main_loop
            ${stall_count}=    Evaluate    ${stall_count} + 1
            Log Warn    [Stall Check] Page source SAME for ${parent_child_identifier_for_log} after main scroll. Stall count: ${stall_count}/${PRODUCT_SOURCE_STALL_THRESHOLD}
            IF    ${stall_count} >= ${PRODUCT_SOURCE_STALL_THRESHOLD}
                Log Info    [End Detect] Page source stalled for ${parent_child_identifier_for_log}. Assuming end of list.
                ${reached_end}=    Set Variable    ${TRUE}
            END
        ELSE
            ${stall_count}=    Set Variable    0    
            ${source_before_main_loop}=    Set Variable    ${source_after_main_scroll}
        END
    END
    Log Info    Finished product scroll for ${parent_child_identifier_for_log}. Reached end: ${reached_end}.

Explore Product Page Tabs And Their Products
    [Arguments]    ${clicked_entry_child_name}     
    [Documentation]    Identifies sub-tabs on current product page, clicks each UNPROCESSED tab,
    ...              scrolls its products, and MARKS THE SUB-TAB NAME AS PROCESSED.
    ...              If no tabs, scrolls products on current page.

    ${key_exists_in_map}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${CATEGORY_FILENAME_MAP}    ${clicked_entry_child_name}
    IF    ${key_exists_in_map}
        ${safe_base_name_for_log}=    Get From Dictionary    ${CATEGORY_FILENAME_MAP}    ${clicked_entry_child_name}
    ELSE
        Log Warn    Entry child name '${clicked_entry_child_name}' not found in CATEGORY_FILENAME_MAP. Using original name for logging/screenshots.
        ${safe_base_name_for_log}=    Set Variable    ${clicked_entry_child_name}
    END
    Log Info    Starting exploration of product page tabs for Entry Child: ${clicked_entry_child_name} (SafeName: ${safe_base_name_for_log})

    Wait Until Element Is Visible With Retry    ${PRODUCT_LIST_TOOLBAR_TITLE}    timeout=${ELEMENT_WAIT_TIMEOUT}

    ${tab_container_locator}=       Set Variable    ${SUB_CATEGORY_TABS_CONTAINER}
    ${tab_text_elements_locator}=   Set Variable    ${ALL_SUB_CATEGORY_TAB_TEXT_ELEMENTS}

    ${is_tab_container_present}=    Run Keyword And Return Status    Page Should Contain Element    ${tab_container_locator}    timeout=${SHORT_TIMEOUT}
    IF    not ${is_tab_container_present}
        Log Info    No product page tab container (${tab_container_locator}) found for ${clicked_entry_child_name}. Scrolling current page.
        Scroll Products Under Current Tab    ${safe_base_name_for_log}_no_tabs
        RETURN
    END

    Log Info    Product page tab container found. Processing tabs for ${clicked_entry_child_name}.
    @{processed_tab_texts_on_this_page_locally}=    Create List    
    ${max_horizontal_tab_scrolls}=    Get Variable Value    ${MAX_HORIZONTAL_CHILD_SCROLLS}    5

    FOR    ${h_scroll_num}    IN RANGE    ${max_horizontal_tab_scrolls}
        ${new_tab_found_and_processed_this_swipe}=    Set Variable    ${False}
        ${visible_tab_elements}=    Get WebElements With Retry    ${tab_text_elements_locator}
        Log Debug    Found ${visible_tab_elements.__len__()} visible tab TextViews in container.

        FOR    ${tab_element}    IN    @{visible_tab_elements}
            TRY
                ${tab_text_raw}=    Get Text With Retry    ${tab_element}
                ${tab_text}=    Strip String    ${tab_text_raw}
                Continue For Loop If    "${tab_text}" == ""
            EXCEPT
                Log Warn    Could not get text from a tab element. Skipping it.
                Continue For Loop
            END

            ${is_tab_globally_processed}=    Is Child Category Already Processed    ${tab_text}
            ${is_tab_locally_processed_this_page}=    Run Keyword And Return Status
            ...    List Should Contain Value    ${processed_tab_texts_on_this_page_locally}    ${tab_text}

            IF    ${is_tab_globally_processed}
                Log Info    Sub-tab "${tab_text}" (under ${clicked_entry_child_name}) already globally processed. Skipping.
                Run Keyword If    not ${is_tab_locally_processed_this_page}    Append To List    ${processed_tab_texts_on_this_page_locally}    ${tab_text}
                Continue For Loop
            END

            IF    not ${is_tab_locally_processed_this_page}   
                Log Info    Processing NEW sub-tab: "${tab_text}" (under Entry Child: ${clicked_entry_child_name})
                TRY
                    Click Element With Retry    ${tab_element}
                    Sleep    1.5s
                    ${tab_identifier_for_log}=    Set Variable    ${safe_base_name_for_log}_SUBTAB_${tab_text}
                    Scroll Products Under Current Tab    ${tab_identifier_for_log}

                    Append To List    ${processed_tab_texts_on_this_page_locally}    ${tab_text}    
                    Mark Child Category As Processed    ${tab_text}  
                    Log Info    Sub-tab "${tab_text}" marked as globally processed.

                    ${new_tab_found_and_processed_this_swipe}=    Set Variable    ${True}
                EXCEPT    *    AS    ${click_err}
                    Log Warn    Failed to click or process sub-tab "${tab_text}": ${click_err}.
                    Append To List    ${processed_tab_texts_on_this_page_locally}    ${tab_text}   
                END
            ELSE
                Log Debug    Sub-tab "${tab_text}" already processed in this local page view for ${clicked_entry_child_name}.
            END
        END

        ${is_last_h_scroll}=    Evaluate    ${h_scroll_num} == ${max_horizontal_tab_scrolls} - 1
        IF    not ${new_tab_found_and_processed_this_swipe} and not ${is_last_h_scroll}
            Log Info    No new unprocessed tabs found in this view. Scrolling tab container for more.
            Scroll Right On Element    ${tab_container_locator}
            Sleep    1.0s
        ELSE IF    not ${new_tab_found_and_processed_this_swipe} and ${is_last_h_scroll}
            Log Info    No new unprocessed tabs found and max horizontal scrolls reached. Assuming all tabs for ${clicked_entry_child_name} processed.
            Exit For Loop
        END
    END
    Log Info    Finished exploring product page sub-tabs for Entry Child: ${clicked_entry_child_name}.