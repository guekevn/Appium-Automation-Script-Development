*** Settings ***
Library    AppiumLibrary
Library    BuiltIn
Library    OperatingSystem
Library    DateTime

*** Variables ***
${PROJECT_ROOT}                 ${CURDIR}/../..
${PROJECT_ROOT_REPORTS_DIR}     ${PROJECT_ROOT}/reports
${SCREENSHOTS_SUB_DIR}          screenshots
${TIMESTAMP_FORMAT}             %Y%m%d_%H%M%S%f

*** Keywords ***
Initialize Logging
    ${screenshot_path}=    Normalize Path    ${PROJECT_ROOT_REPORTS_DIR}${/}${SCREENSHOTS_SUB_DIR}
    Create Directory    ${screenshot_path}
    Log    Logging initialized. Screenshots will be saved under: ${screenshot_path}

Log Info
    [Arguments]    ${message}
    Log    ${message}    level=INFO

Log Debug
    [Arguments]    ${message}
    Log    ${message}    level=DEBUG

Log Warn
    [Arguments]    ${message}
    Log    ${message}    level=WARN

Log Error
    [Arguments]    ${message}
    Log    ${message}    level=ERROR

Log Activity And Take Screenshot
    [Arguments]    ${base_filename}    ${subfolder}=general
    Log Info    [ACTIVITY] ${base_filename} (Target Folder: ${subfolder})
    ${safe_subfolder}=    Evaluate    $subfolder.replace('/', '_').replace(' ', '_').lower()  
    ${screenshot_target_dir}=    Normalize Path    ${PROJECT_ROOT_REPORTS_DIR}${/}${SCREENSHOTS_SUB_DIR}${/}${safe_subfolder}
    Create Directory    ${screenshot_target_dir}
    ${timestamp}=    Get Current Date    result_format=${TIMESTAMP_FORMAT}
    ${safe_base_filename}=    Evaluate    $base_filename.replace('/', '_').replace(' ', '_').lower()  
    ${filename_base}=    Set Variable    ${safe_base_filename}_${timestamp}.png
    ${full_path}=        Normalize Path    ${screenshot_target_dir}${/}${filename_base}
    ${relative_path}=    Normalize Path    ${SCREENSHOTS_SUB_DIR}/${safe_subfolder}/${filename_base}
    ${status}=    Run Keyword And Return Status    Capture Page Screenshot    ${full_path}
    IF    not ${status}
        Log Warn    [WARN] Failed to capture screenshot: ${full_path}
    ELSE
        Log Info    Screenshot saved to: ${full_path}
        Log    <img src="${relative_path}" width="300px" style="border:1px solid grey;">    html=True
    END