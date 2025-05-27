*** Settings ***
Library           OperatingSystem
Library           String
Library           BuiltIn
Resource          ../keywords/logging_keywords.resource

*** Variables ***
${PROCESSED_CHILDREN_TRACKER_FILE}    ${OUTPUT_DIR}/processed_children_tracker.txt

*** Keywords ***
Initialize Child Category Tracker
    Log Info    Initializing child category tracker file: ${PROCESSED_CHILDREN_TRACKER_FILE}
    Create File    ${PROCESSED_CHILDREN_TRACKER_FILE}  

Mark Child Category As Processed
    [Arguments]    ${child_category_name}
    ${unique_identifier}=    Catenate    SEPARATOR=::    ${SUITE_NAME}    ${child_category_name}  
    Log Info    Marking child category "${child_category_name}" (ID: ${unique_identifier}) as processed.
    Append To File    ${PROCESSED_CHILDREN_TRACKER_FILE}    ${unique_identifier}\n

Is Child Category Already Processed
    [Arguments]    ${child_category_name_to_check}
    ${file_exists}=    Run Keyword And Return Status    File Should Exist    ${PROCESSED_CHILDREN_TRACKER_FILE}
    IF    not ${file_exists}
        Log Warn    Tracker file ${PROCESSED_CHILDREN_TRACKER_FILE} does not exist. Assuming child "${child_category_name_to_check}" not processed.
        RETURN    ${False}
    END

    ${unique_identifier_to_check}=    Catenate    SEPARATOR=::    ${SUITE_NAME}    ${child_category_name_to_check}
    ${content}=    Get File    ${PROCESSED_CHILDREN_TRACKER_FILE}
    @{lines}=    Split To Lines    ${content}
    FOR    ${line_from_file}    IN    @{lines}
        ${trimmed_line}=    Strip String    ${line_from_file}
        IF    '${trimmed_line}' == '${unique_identifier_to_check}'
            Log Info    Child category "${child_category_name_to_check}" (ID: ${unique_identifier_to_check}) FOUND in tracker.
            RETURN    ${True}
        END
    END
    Log Info    Child category "${child_category_name_to_check}" (ID: ${unique_identifier_to_check}) NOT found in tracker.
    RETURN    ${False}