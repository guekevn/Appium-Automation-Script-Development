*** Settings ***
Library    BuiltIn
Library    AppiumLibrary
Library    OperatingSystem
Library    DateTime 

*** Variables ***
${LOG_DIR}    ${EXECDIR}/logs 
${TIMESTAMP_FORMAT}    %Y%m%d_%H%M%S 

*** Keywords ***
Initialize Logging
    [Documentation]    Creates the base screenshots directory within the Robot Framework output folder.
    Create Directory    ${OUTPUT DIR}${/}screenshots
    Log    Logging initialized. Screenshots will be saved under: ${OUTPUT DIR}${/}screenshots

Log Message
    [Arguments]    ${level}    ${message}
    ${timestamp}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S.%f
    # ${log_file}=    Set Variable    ${OUTPUT DIR}/test_execution.log
    ${log_entry}=    Set Variable    ${timestamp} [${level}] ${message}
    # Append To File    ${log_file}    ${log_entry}\n
    Log    ${log_entry} 

Log Info
    [Arguments]    ${message}
    Log Message    INFO    ${message}

Log Error
    [Arguments]    ${message}
    Log Message    ERROR    ${message}

Log Debug
    [Arguments]    ${message}
    Log Message    DEBUG    ${message}

Log Activity And Take Screenshot
    [Arguments]    ${base_filename}    ${subfolder}=general
    Log    [ACTIVITY] ${base_filename} (Target Folder: ${subfolder})

    ${screenshot_target_dir}=    Normalize Path    ${OUTPUT DIR}${/}screenshots${/}${subfolder}
    Create Directory    ${screenshot_target_dir}

    ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S%f
    ${filename}=    Normalize Path    ${screenshot_target_dir}${/}${base_filename}_${timestamp}.png

    ${status}=    Run Keyword And Return Status    Capture Page Screenshot    ${filename}
    IF    not ${status}
         Log    [WARN] Failed to capture screenshot: ${filename}
    ELSE
         Log    Screenshot saved to: ${filename}
         Log    <img src="screenshots/${subfolder}/${base_filename}_${timestamp}.png" width="300px" style="border:1px solid grey;">
    END