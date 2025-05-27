*** Variables ***
${TOOLBAR_TITLE_INDICATOR}                 id=com.todoorstep.store:id/tvToolbarTitle

${PRODUCT_PAGE_TITLE_FOR_LAYOUT_V1}        Product List
${PRODUCT_PAGE_TITLE_FOR_LAYOUT_V2}        Categories

${PRODUCT_CONTAINER_V1_GRIDVIEW}           id=com.todoorstep.store:id/rvProductList
${PRODUCT_ITEM_TITLE_ALL_V1}               xpath=//android.widget.GridView[@resource-id="com.todoorstep.store:id/rvProductList"]/descendant::android.widget.TextView[@resource-id='com.todoorstep.store:id/tvProductTitle']

${PRODUCT_CONTAINER_V2_RECYCLER}           id=com.todoorstep.store:id/rvProductList
${PRODUCT_ITEM_TITLE_ALL_V2}               xpath=//androidx.recyclerview.widget.RecyclerView[@resource-id="com.todoorstep.store:id/rvProductList"]/descendant::android.widget.TextView[@resource-id="com.todoorstep.store:id/tvProductTitle"]

${EMPTY_PRODUCT_LIST_TITLE}                id=com.todoorstep.store:id/empty_title 