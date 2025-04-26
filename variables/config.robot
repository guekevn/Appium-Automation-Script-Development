*** Variables ***
# Appium Configuration
${APPIUM_SERVER}          http://127.0.0.1:4723
${PLATFORM_NAME}          Android
${AUTOMATION_NAME}        UiAutomator2
${DEVICE_NAME}            0C73C18I221016C7
${APP_PACKAGE}            com.todoorstep.store
${APP_ACTIVITY}           com.todoorstep.store.ui.activities.authentication.AuthActivity
${NO_RESET}               true

#Timing configuration
${ELEMENT_WAIT_TIMEOUT}     15s
${IMPLICIT_WAIT_TIMEOUT}    10s
${PAUSE_AFTER_CLICK}        2s
${PAUSE_AFTER_SCROLL}       1.5

#Data categories & Map
@{CATEGORIES}    
...    Fruits & Veggies    
...    Meat & Poultry    
...    Water    
...    Bakery    
...    Cheese & Deli    
...    Breakfast    
...    Cooking Essentials    
...    Frozen Products    
...    Food Basics    
...    Snacks    
...    Beverages    
...    Milk & Dairy    
...    Home Care & Laundry    
...    Pet Care    
...    Electronics    
...    Baby Care    
...    Personal Care    
...    Beauty Care

&{CATEGORY_FILENAME_MAP}    
...    Fruits & Veggies=fruits_veggies
...    Meat & Poultry=meat_poultry
...    Water=water
...    Bakery=bakery
...    Cheese & Deli=cheese_deli
...    Breakfast=breakfast
...    Cooking Essentials=cooking_essentials
...    Frozen Products=frozen_products
...    Food Basics=food_basics
...    Snacks=snacks
...    Beverages=beverages
...    Milk & Dairy=milk_dairy
...    Home Care & Laundry=home_care_laundry
...    Pet Care=pet_care
...    Electronics=electronics
...    Baby Care=baby_care
...    Personal Care=personal_care
...    Beauty Care=beauty_care