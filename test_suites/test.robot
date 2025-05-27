*** Settings ***
Documentation     Test suite explores one entry child per parent category, processes ...
Library           AppiumLibrary
Library           Collections
Library           OperatingSystem
Library           BuiltIn

Resource          ../resources/keywords/common_keywords.resource
Resource          ../resources/keywords/guest_keywords.resource
Resource          ../resources/keywords/categories_page_keywords.resource
Resource          ../resources/keywords/product_keywords.resource
Resource          ../resources/keywords/logging_keywords.resource
Resource          ../resources/variables/config.resource
Resource          ../resources/locators/common_locators.resource
Resource          ../resources/keywords/tracking_keywords.resource

Suite Setup       Run Keywords    Initialize Logging    AND    Initialize Child Category Tracker
Test Setup        Start Test Session
Test Teardown     End Test Session

*** Test Cases ***
Explore Designated Entry Child And SubTabs For Each Parent
    [Documentation]    For each parent, clicks its single designated entry child.
    ...                Explores all product sub-tabs of that entry child, even if entry child page is initially empty.
    ...                Sub-tab names are marked as processed. After an entry child's sub-tabs are done, moves to next parent.
    [Tags]    Smoke    SingleEntryPerParent    SubTabTracking    HandleEmptyEntryPage

    Enter Guest Mode
    Navigate To Categories Tab
    
    ${test_parent} =     Create List    Personal Care
    FOR    ${parent_name}    IN    @{test_parent}
        ${header_line_parent}=    Evaluate    "===" * 10
        ${log_message_parent_start}=    Catenate    SEPARATOR=
        ...    \n${header_line_parent}
        ...    Processing Parent Category: ${parent_name}
        ...    ${header_line_parent}
        Log Info    ${log_message_parent_start}

        IF    ${INDEX} > 0
            Scroll To Top Of Categories Page
        END
        Set Suite Variable    ${INDEX}    ${INDEX}+1

        Scroll Vertically Until Parent And Child Container Are Optimal    ${parent_name}

        ${entry_child_list_exists}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${PARENT_TO_ENTRY_CHILD_MAP}    ${parent_name}
        IF    not ${entry_child_list_exists}
            Log Warn    Parent category "${parent_name}" not in PARENT_TO_ENTRY_CHILD_MAP. Skipping.
            CONTINUE FOR LOOP
        END
        @{designated_entry_child_list}=    Get From Dictionary    ${PARENT_TO_ENTRY_CHILD_MAP}    ${parent_name}

        ${num_entry_children}=    Get Length    ${designated_entry_child_list}
        IF    ${num_entry_children} == 0
            Log Info    Parent "${parent_name}" has no designated entry child in PARENT_TO_ENTRY_CHILD_MAP. Skipping.
            CONTINUE FOR LOOP
        END
        Run Keyword If    ${num_entry_children} > 1    Log Warn
        ...    Parent "${parent_name}" has ${num_entry_children} children in PARENT_TO_ENTRY_CHILD_MAP. ONLY THE FIRST WILL BE PROCESSED.
        ${entry_child_to_click}=    Set Variable    ${designated_entry_child_list[0]}

        Log Info    -- Designated Entry Child for ${parent_name}: "${entry_child_to_click}" --

        ${is_entry_child_already_processed}=    Is Child Category Already Processed    ${entry_child_to_click}
        IF    ${is_entry_child_already_processed}
            Log Info    Designated Entry Child "${entry_child_to_click}" for parent "${parent_name}" has already been processed. Skipping to next parent.
            CONTINUE FOR LOOP
        END

        Find And Click Specific Child In Visible Container    ${parent_name}    ${entry_child_to_click}
        Log Info    Clicked Entry Child: "${entry_child_to_click}". Now on its product list page.

        ${key_in_map}=    Run Keyword And Return Status    Dictionary Should Contain Key    ${CATEGORY_FILENAME_MAP}    ${entry_child_to_click}
        ${safe_entry_child_name_for_file}=    Set Variable If    ${key_in_map}
        ...    Get From Dictionary    ${CATEGORY_FILENAME_MAP}    ${entry_child_to_click}
        ...    ELSE    ${entry_child_to_click}
        Run Keyword If    not ${key_in_map}    Log Warn
        ...    Entry child '${entry_child_to_click}' NOT FOUND in CATEGORY_FILENAME_MAP. Using original name.

        ${is_product_page_empty}=    Run Keyword And Return Status    Page Should Contain Element    ${EMPTY_PRODUCT_LIST_INDICATOR}    timeout=${VERY_SHORT_TIMEOUT}
        IF    ${is_product_page_empty}
            Log Warn    Product page for Entry Child "${entry_child_to_click}" (Parent: ${parent_name}) is directly EMPTY.
            Run Keyword If    ${ENABLE_ALL_SCREENSHOTS}    Log Activity And Take Screenshot
            ...    ${parent_name}_${safe_entry_child_name_for_file}_empty
            ...    ${parent_name}/${safe_entry_child_name_for_file}
            Log Info    Even though entry page is empty, proceeding to explore potential sub-tabs for "${entry_child_to_click}".
            Explore Product Page Tabs And Their Products    ${entry_child_to_click}
        ELSE
            Log Info    Product page for "${entry_child_to_click}" not directly empty. Exploring product page (and sub-tabs)...
            Explore Product Page Tabs And Their Products    ${entry_child_to_click}
        END

        Mark Child Category As Processed    ${entry_child_to_click}
        Log Info    Finished processing Entry Child "${entry_child_to_click}" and its sub-tabs for parent "${parent_name}".

        Log Info    Returning to Categories Page to proceed to the NEXT PARENT.
        Press Keycode With Retry    ${ANDROID_SYSTEM_BACK_KEYCODE}
        Wait Until Page Contains Element    ${CATEGORIES_PAGE_TOOLBAR_TITLE}    timeout=${ELEMENT_WAIT_TIMEOUT}
        Log Info    Returned to Categories Page.

        ${footer_line_parent}=    Evaluate    "===" * 10
        ${log_message_parent_end}=    Catenate    SEPARATOR=
        ...    ${footer_line_parent} Completed processing for Parent Category: ${parent_name} ${footer_line_parent}
        Log Info    ${log_message_parent_end}
        Sleep    1s
    END

    ${footer_line_suite}=    Evaluate    "***" * 10
    ${log_message_suite_end}=    Catenate    SEPARATOR=
    ...    \n${footer_line_suite}
    ...    Successfully completed exploration of all designated entry children and their sub-tabs.
    ...    ${footer_line_suite}
    Log Info    ${log_message_suite_end}

*** Variables ***
${INDEX}    ${0}