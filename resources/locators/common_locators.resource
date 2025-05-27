*** Variables ***
${GUEST_MODE_BUTTON}                       xpath=//android.widget.TextView[@text="Shop as a guest"]
${HOME_PAGE_INDICATOR}                     id=com.todoorstep.store:id/nav_home

${NAV_CATEGORIES_TAB}                      id=com.todoorstep.store:id/nav_category
${NAV_HOME_TAB}                            id=com.todoorstep.store:id/nav_home

${CATEGORIES_PAGE_TOOLBAR_TITLE}                             xpath=//android.widget.TextView[@text='Categories' and @resource-id='com.todoorstep.store:id/tvToolbarTitle']
${PARENT_CATEGORY_TEXT_TEMPLATE}                             xpath=//androidx.compose.ui.platform.ComposeView/descendant::android.widget.TextView[@text="\${text_to_find}"]

${CHILD_HORIZONTAL_LIST_CONTAINER_AFTER_PARENT_TEMPLATE}     xpath=//android.widget.TextView[@text="\${parent_text_placeholder}"]/following-sibling::*[self::android.view.View[@scrollable='true']][1]

${PRODUCT_LIST_TOOLBAR_TITLE}              id=com.todoorstep.store:id/tvToolbarTitle
${SUB_CATEGORY_TABS_CONTAINER}             id=com.todoorstep.store:id/tlSubCategories
${ALL_SUB_CATEGORY_TAB_TEXT_ELEMENTS}      xpath=//android.widget.HorizontalScrollView[@resource-id='com.todoorstep.store:id/tlSubCategories']//android.widget.TextView
${SUB_CATEGORY_TAB_TEMPLATE}               xpath=//android.widget.HorizontalScrollView[@resource-id='com.todoorstep.store:id/tlSubCategories']//android.widget.TextView[@text="\${text_to_find}"]

${EMPTY_PRODUCT_LIST_INDICATOR}            id=com.todoorstep.store:id/empty_title
${NO_MORE_PRODUCTS_TEXT}                   xpath=//android.widget.TextView[contains(@text,'No more products')]
${ANDROID_SYSTEM_BACK_KEYCODE}             4