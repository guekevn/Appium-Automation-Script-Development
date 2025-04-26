*** Settings ***
Library         AppiumLibrary
Library         Collections
Library         OperatingSystem
Library         String                  
Resource        common.robot            
Resource        logs.robot
Resource        ../locators/products_locators.robot         
Resource        ../locators/categories_locators.robot    
Resource        ../variables/config.robot   

*** Keywords ***
Explore And Capture Product List
    [Arguments]    ${category_name}    ${max_scrolls}=15
    ${safe_name}=    Get From Dictionary    ${CATEGORY_FILENAME_MAP}    ${category_name}
    Log Info    Starting product list exploration for category: ${category_name} (Safe Name: ${safe_name})

    TRY

        Wait Until Element Is Visible    ${PRODUCT_LIST_INDICATOR}    timeout=20s
        Log Info    Product list page loaded for ${category_name}.

        ${screenshot_count}=    Set Variable    1
        Log Activity And Take Screenshot    ${safe_name}_products_page_${screenshot_count}    ${safe_name}

        ${source_before}=    Get Source
        FOR    ${i}    IN RANGE    ${max_scrolls} # FOR Loop Start
            ${next_page_number}=    Evaluate    ${screenshot_count} + 1
            Log Info    Scrolling down page ${next_page_number} for ${category_name} (Scroll attempt ${i+1}/${max_scrolls})

            Scroll Down Safely

            ${source_after}=    Get Source

            IF    $source_before == $source_after # IF Block 1 Start
                Log Info    Page source did not change. Reached bottom for ${category_name}.
                Exit For Loop
            END 

            ${screenshot_count}=    Evaluate    ${screenshot_count} + 1
            Log Activity And Take Screenshot    ${safe_name}_products_page_${screenshot_count}    ${safe_name}

            ${source_before}=    Set Variable    ${source_after}

            ${found_footer}=    Run Keyword And Return Status    Page Should Contain Element    ${NO_MORE_PRODUCTS_TEXT}

            Run Keyword If    ${found_footer}
            ...    Log Info    Detected end-of-list element. Exiting loop.
            ...    Exit For Loop
            
        END

        IF    ${i} == ${max_scrolls}-1
            Log Info    Reached maximum scroll limit (${max_scrolls}) for ${category_name}.
        END
        Log Info    Finished exploring products for ${category_name}. Total pages captured: ${screenshot_count}
    
    EXCEPT    WebDriverException    type=glob 
        Log Error    CRITICAL: Appium connection lost during product list exploration for category '${category_name}'. Instrumentation process likely crashed. Check logs.
    
        Fail    Appium connection lost (WebDriverException) for category: ${category_name}
    END
