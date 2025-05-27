*** Variables ***
# Appium Configuration
${APPIUM_SERVER}                    http://127.0.0.1:4723
${PLATFORM_NAME}                    Android
${AUTOMATION_NAME}                  UiAutomator2
${DEVICE_NAME}                      0C73C18I221016C7
${APP_PACKAGE}                      com.todoorstep.store
${APP_ACTIVITY}                     com.todoorstep.store.ui.activities.authentication.AuthActivity
${NO_RESET}                         ${True}

# Timing Configuration
${ELEMENT_WAIT_TIMEOUT}                 15s
${IMPLICIT_WAIT_TIMEOUT}                10s
${PAUSE_AFTER_CLICK}                    1.0s
${PAUSE_AFTER_SCROLL}                   1.0s
${SHORT_TIMEOUT}                        5s
${VERY_SHORT_TIMEOUT}                   1s

# Scroll Settings
${SCROLL_START_Y_PERCENT}                   0.8
${SCROLL_END_Y_PERCENT}                     0.2
${SCROLL_X_PERCENT}                         0.5
${SCROLL_DURATION_MS}                       700
${SMALL_SCROLL_UP_START_Y}                  0.7
${SMALL_SCROLL_UP_END_Y}                    0.3
${SMALL_SCROLL_DOWN_START_Y}                0.5
${SMALL_SCROLL_DOWN_END_Y}                  0.3
${SMALL_SCROLL_DURATION_MS}                 400
${CATEGORY_PAGE_SOURCE_STALL_THRESHOLD}     3
${MAX_PAGE_SCROLLS}                         15
${MAX_HORIZONTAL_CHILD_SCROLLS}             10
${PRODUCT_EXPLORE_DEPTH}                    40
${PRODUCT_SOURCE_STALL_THRESHOLD}           3
${MAX_INITIAL_PRODUCT_SCROLLS}              5
${MAX_POSITIONING_ATTEMPTS}                 3 
${ACCEPTABLE_Y_RANGE_TOP_PERCENTAGE}        0.10 
${ACCEPTABLE_Y_RANGE_BOTTOM_PERCENTAGE}     0.40 
${MIN_PIXEL_OVERLAP_FOR_VISIBILITY}         10   

# --- List Parent Categories ---
@{ORDERED_PARENT_CATEGORIES}=
...    Saudi Made
...    Fresh
...    Food Basics
...    Cooking Essentials
...    Candy Corner
...    Kashta
...    Health & Wellness
...    Ready to Eat
...    Breakfast
...    Bakery
...    Frozen
...    Beverages
...    Snacks
...    Baby Care
...    Personal Care
...    Household
...    Electronics
...    Water
...    Pets Care
...    Beauty Care

@{SAUDI_MADE_CHILDREN}=             Food Basics    Breakfast    Household    Beauty Care    Cooking Essentials    Personal Care    Fresh    Snacks    Frozen    Beverages
@{FRESH_CHILDREN}=                  Dairy & Eggs    Fish & Seafood    Meat & Poultry    Fruits & Vegetables    Deli    Cheese & Labneh    Dates
@{FOOD_BASICS_CHILDREN}=            Sugar & Sweeteners    Pasta & Noodles    Oil & Ghee    Rice & Grains
@{COOKING_ESSENTIALS_CHILDREN}=     Olives & Pickles    World foods / Asian foods    Home Baking    Desserts    Tinned, Cans & Packets    Soup    Dried Fruits, Nuts & Seeds    Cooking Ingredients    Sauce, Marinades & Dressing
@{CANDY_CORNER_CHILDREN}=           Mints & Gums    Candies & Jelly sweets
@{KASHTA_CHILDREN}=                 Camping    Personal Care    Frozen    Snacks    Beverages    Cooking Essentials    Breakfast    Bakery    Fresh
@{HEALTH_WELLNESS_CHILDREN}=        Cholestrol Free    Lactose Free    Vegan    Keto    Gluten Free    Protein    Organic    Sugar Free
@{READY_TO_EAT_CHILDREN}=           Breakfast    Sandwiches    Fruits Cuts    Salad Cuts    Fresh Juices
@{BREAKFAST_CHILDREN_MAIN}=         Long Life Milk & Other Products    Honey, Jams & Spreads    Cereal 
@{BAKERY_CHILDREN}=                 Donuts & Muffins    Dessert and Cakes    Croissants & Pastries    Rusks    Breads & Rolls
@{FROZEN_CHILDREN_MAIN}=            Ready to Bake & Eat    Ice Creams & Desserts    Pizza    Pastries & Sambusa    Fish & Seafood    Meat & Poultry    French Fries & Onion Rings    Fruits & Vegetables 
@{BEVERAGES_CHILDREN_MAIN}=         Others Beverages    Coffee    Tea & Herbal Drinks    Juices    Energy Drinks    Carbonated Drinks
@{SNACKS_CHILDREN_MAIN}=            Healthy Snacks    Candies & Jelly sweets    Nuts & Dried Fruit    Mints & Gums    Biscuits & Cookies    Chips    Popcorn    Chocolate
@{BABY_CARE_CHILDREN}=              Baby Accessories    Baby Food & Snacks    Baby Formula & Milks    Baby Toiletries    Baby Wipes    Diapers & Pants
@{PERSONAL_CARE_CHILDREN_MAIN}=     Oils    Body Care    Male Personal Care    Female Personal Care    Shower Bath & Soap    Oral Care    Pharmaceutical care
@{HOUSEHOLD_CHILDREN_MAIN}=         Toys    Stationary    Luggage    Houseware    DISPOSABLES    Pest Control    Camping    Brushes, Mops and Buckets    Household Essentials & Food    Air Freshener    Dishwashing    Cleaning    Tissues    Kitchen Roll    Toilet Roll    Laundry
@{ELECTRONICS_CHILDREN}=            Home Care    Accessories    Food & Beverages
@{WATER_CHILDREN}=                  Sparkling Water    Still Water
@{PETS_CARE_CHILDREN}=              Dogs    Birds    Cat
@{BEAUTY_CARE_CHILDREN_MAIN}=       Perfumes    Beauty Accessories &    Hair Care    Facial Skin Care

&{PARENT_CHILD_CATEGORIES}
...    Saudi Made=${SAUDI_MADE_CHILDREN}
...    Fresh=${FRESH_CHILDREN}
...    Food Basics=${FOOD_BASICS_CHILDREN}
...    Cooking Essentials=${COOKING_ESSENTIALS_CHILDREN}
...    Candy Corner=${CANDY_CORNER_CHILDREN}
...    Kashta=${KASHTA_CHILDREN}
...    Health & Wellness=${HEALTH_WELLNESS_CHILDREN}
...    Ready to Eat=${READY_TO_EAT_CHILDREN}
...    Breakfast=${BREAKFAST_CHILDREN_MAIN}
...    Bakery=${BAKERY_CHILDREN}
...    Frozen=${FROZEN_CHILDREN_MAIN}
...    Beverages=${BEVERAGES_CHILDREN_MAIN}
...    Snacks=${SNACKS_CHILDREN_MAIN}
...    Baby Care=${BABY_CARE_CHILDREN}
...    Personal Care=${PERSONAL_CARE_CHILDREN_MAIN}
...    Household=${HOUSEHOLD_CHILDREN_MAIN}
...    Electronics=${ELECTRONICS_CHILDREN}
...    Water=${WATER_CHILDREN}
...    Pets Care=${PETS_CARE_CHILDREN}
...    Beauty Care=${BEAUTY_CARE_CHILDREN_MAIN}

@{SAUDI_MADE_MAIN_ENTRY}=               Food Basics  
@{FRESH_MAIN_ENTRY}=                    Dairy & Eggs
@{FOOD_BASICS_MAIN_ENTRY}=              Sugar & Sweeteners 
@{COOKING_ESSENTIALS_MAIN_ENTRY}=       Olives & Pickles
@{CANDY_CORNER_MAIN_ENTRY}=             Mints & Gums
@{KASHTA_MAIN_ENTRY}=                   Camping
@{HEALTH_WELLNESS_MAIN_ENTRY}=          Cholestrol Free
@{READY_TO_EAT_MAIN_ENTRY}=             Breakfast  
@{BREAKFAST_PARENT_MAIN_ENTRY}=         Long Life Milk & Other Products 
@{BAKERY_MAIN_ENTRY}=                   Donuts & Muffins
@{FROZEN_PARENT_MAIN_ENTRY}=            Ready to Bake & Eat 
@{BEVERAGES_PARENT_MAIN_ENTRY}=         Others Beverages
@{SNACKS_PARENT_MAIN_ENTRY}=            Healthy Snacks
@{BABY_CARE_MAIN_ENTRY}=                Diapers & Pants
@{PERSONAL_CARE_PARENT_MAIN_ENTRY}=     Oils
@{HOUSEHOLD_PARENT_MAIN_ENTRY}=         Toys
@{ELECTRONICS_MAIN_ENTRY}=              Home Care
@{WATER_MAIN_ENTRY}=                    Sparkling Water
@{PETS_CARE_MAIN_ENTRY}=                Dogs
@{BEAUTY_CARE_PARENT_MAIN_ENTRY}=       Perfumes 

&{PARENT_TO_ENTRY_CHILD_MAP}
...    Saudi Made=${SAUDI_MADE_MAIN_ENTRY}
...    Fresh=${FRESH_MAIN_ENTRY}
...    Food Basics=${FOOD_BASICS_MAIN_ENTRY}
...    Cooking Essentials=${COOKING_ESSENTIALS_MAIN_ENTRY}
...    Candy Corner=${CANDY_CORNER_MAIN_ENTRY}
...    Kashta=${KASHTA_MAIN_ENTRY}
...    Health & Wellness=${HEALTH_WELLNESS_MAIN_ENTRY}
...    Ready to Eat=${READY_TO_EAT_MAIN_ENTRY}
...    Breakfast=${BREAKFAST_PARENT_MAIN_ENTRY}
...    Bakery=${BAKERY_MAIN_ENTRY}
...    Frozen=${FROZEN_PARENT_MAIN_ENTRY}
...    Beverages=${BEVERAGES_PARENT_MAIN_ENTRY}
...    Snacks=${SNACKS_PARENT_MAIN_ENTRY}
...    Baby Care=${BABY_CARE_MAIN_ENTRY}
...    Personal Care=${PERSONAL_CARE_PARENT_MAIN_ENTRY}
...    Household=${HOUSEHOLD_PARENT_MAIN_ENTRY}
...    Electronics=${ELECTRONICS_MAIN_ENTRY}
...    Water=${WATER_MAIN_ENTRY}
...    Pets Care=${PETS_CARE_MAIN_ENTRY}
...    Beauty Care=${BEAUTY_CARE_PARENT_MAIN_ENTRY}

&{CATEGORY_FILENAME_MAP}
    # --- Saudi Made Children ---
...    Food Basics=food_basics_saudi_made
...    Breakfast=breakfast_saudi_made
...    Household=household_saudi_made
...    Beauty Care=beauty_care_saudi_made       
...    Cooking Essentials=cooking_essentials_saudi_made
...    Personal Care=personal_care_saudi_made
...    Fresh=fresh_saudi_made
...    Snacks=snacks_saudi_made
...    Frozen=frozen_saudi_made
...    Beverages=beverages_saudi_made
    # --- Fresh Children ---
...    Dairy & Eggs=dairy_and_eggs_fresh
...    Fish & Seafood=fish_and_seafood_fresh
...    Meat & Poultry=meat_and_poultry_fresh
...    Fruits & Vegetables=fruits_and_vegetables_fresh
...    Deli=deli_fresh
...    Cheese & Labneh=cheese_and_labneh_fresh
...    Dates=dates_fresh
    # --- Food Basics Children ---
...    Sugar & Sweeteners=sugar_and_sweeteners_foodbasics
...    Pasta & Noodles=pasta_and_noodles_foodbasics
...    Oil & Ghee=oil_and_ghee_foodbasics
...    Rice & Grains=rice_and_grains_foodbasics
    # --- Cooking Essentials Children ---
...    Olives & Pickles=olives_and_pickles_cookingessentials
...    World foods / Asian foods=world_foods_or_asian_foods_cookingessentials
...    Home Baking=home_baking_cookingessentials
...    Desserts=desserts_cookingessentials
...    Tinned, Cans & Packets=tinned_cans_packets_cookingessentials
...    Soup=soup_cookingessentials
...    Dried Fruits, Nuts & Seeds=dried_fruits_nuts_seeds_cookingessentials
...    Cooking Ingredients=cooking_ingredients_cookingessentials
...    Sauce, Marinades & Dressing=sauce_marinades_dressing_cookingessentials
    # --- Candy Corner Children ---
...    Mints & Gums=mints_and_gums_candycorner
...    Candies & Jelly sweets=candies_and_jelly_sweets_candycorner
    # --- Kashta Children ---
...    Camping=camping_kashta
...    Personal Care_Kashta=personal_care_kashta_child 
...    Frozen_Kashta=frozen_kashta_child
...    Snacks_Kashta=snacks_kashta_child
...    Beverages_Kashta=beverages_kashta_child
...    Cooking Essentials_Kashta=cooking_essentials_kashta_child
...    Breakfast_Kashta=breakfast_kashta_child
...    Bakery_Kashta=bakery_kashta_child
...    Fresh_Kashta=fresh_kashta_child
...    Personal Care_Kashta=personal_care_kashta_child
    # --- Health & Wellness Children ---
...    Cholestrol Free=cholestrol_free_health
...    Lactose Free=lactose_free_health
...    Vegan=vegan_health
...    Keto=keto_health
...    Gluten Free=gluten_free_health
...    Protein=protein_health
...    Organic=organic_health
...    Sugar Free=sugar_free_health
    # --- Ready to Eat Children ---
...    Breakfast_ReadyToEat=breakfast_readytoeat_child
...    Sandwiches=sandwiches_readytoeat
...    Fruits Cuts=fruits_cuts_readytoeat
...    Salad Cuts=salad_cuts_readytoeat
...    Fresh Juices=fresh_juices_readytoeat
    # --- Breakfast (Parent) Children ---
...    Long Life Milk & Other Products=long_life_milk_breakfastmain
...    Honey, Jams & Spreads=honey_jams_spreads_breakfastmain
...    Cereal=cereal_breakfastmain
    # --- Bakery (Parent) Children ---
...    Donuts & Muffins=donuts_muffins_bakerymain
...    Dessert and Cakes=dessert_and_cakes_bakerymain
...    Croissants & Pastries=croissants_and_pastries_bakerymain
...    Rusks=rusks_bakerymain
...    Breads & Rolls=breads_and_rolls_bakerymain
    # --- Frozen (Parent) Children ---
...    Ready to Bake & Eat=ready_to_bake_eat_frozenmain
...    Ice Creams & Desserts=ice_creams_desserts_frozenmain
...    Pizza=pizza_frozenmain
...    Pastries & Sambusa=pastries_sambusa_frozenmain
...    Fish & Seafood_Frozen=fish_and_seafood_frozenmain_child
...    Meat & Poultry_Frozen=meat_and_poultry_frozenmain_child
...    French Fries & Onion Rings=french_fries_onion_rings_frozenmain
...    Fruits & Vegetables_Frozen=fruits_and_vegetables_frozenmain_child
    # --- Beverages (Parent) Children ---
...    Others Beverages=others_beverages_beveragesmain
...    Coffee=coffee_beveragesmain
...    Tea & Herbal Drinks=tea_herbal_drinks_beveragesmain
...    Juices=juices_beveragesmain
...    Energy Drinks=energy_drinks_beveragesmain
...    Carbonated Drinks=carbonated_drinks_beveragesmain
    # --- Snacks (Parent) Children ---
...    Healthy Snacks=healthy_snacks_snacksmain
...    Candies & Jelly sweets_Snacks=candies_jelly_sweets_snacksmain_child
...    Nuts & Dried Fruit=nuts_dried_fruit_snacksmain
...    Mints & Gums_Snacks=mints_gums_snacksmain_child
...    Biscuits & Cookies=biscuits_cookies_snacksmain
...    Chips=chips_snacksmain
...    Popcorn=popcorn_snacksmain
...    Chocolate=chocolate_snacksmain
    # --- Baby Care (Parent) Children ---
...    Baby Accessories=baby_accessories_babycare
...    Baby Food & Snacks=baby_food_snacks_babycare
...    Baby Formula & Milks=baby_formula_milks_babycare
...    Baby Toiletries=baby_toiletries_babycare
...    Baby Wipes=baby_wipes_babycare
...    Diapers & Pants=diapers_pants_babycare
    # --- Personal Care (Parent) Children ---
...    Oils=oils_personalcaremain
...    Body Care=body_care_personalcaremain
...    Male Personal Care=male_personal_care_personalcaremain
...    Female Personal Care=female_personal_care_personalcaremain
...    Shower Bath & Soap=shower_bath_soap_personalcaremain
...    Oral Care=oral_care_personalcaremain
...    Pharmaceutical care=pharmaceutical_care_personalcaremain
    # --- Household (Parent) Children ---
...    Toys=toys_householdmain
...    Stationary=stationary_householdmain
...    Luggage=luggage_householdmain
...    Houseware=houseware_householdmain
...    DISPOSABLES=disposables_householdmain
...    Pest Control=pest_control_householdmain
#   Camping=camping_householdmain_child # Duplikat potensial
...    Brushes, Mops and Buckets=brushes_mops_buckets_householdmain
...    Household Essentials & Food=household_essentials_and_food_householdmain
...    Air Freshener=air_freshener_householdmain
...    Dishwashing=dishwashing_householdmain
...    Cleaning=cleaning_householdmain
...    Tissues=tissues_householdmain
...    Kitchen Roll=kitchen_roll_householdmain
...    Toilet Roll=toilet_roll_householdmain
...    Laundry=laundry_householdmain
    # --- Electronics (Parent) Children ---
...    Home Care=home_care_electronics_child
...    Accessories=accessories_electronics
...    Food & Beverages=food_and_beverages_electronics
    # --- Water (Parent) Children ---
...    Sparkling Water=sparkling_water_watermain
...    Still Water=still_water_watermain
    # --- Pets Care (Parent) Children ---
...    Dogs=dogs_petscare
...    Birds=birds_petscare
...    Cat=cat_petscare
    # --- Beauty Care (Parent) Children ---
...    Perfumes=perfumes_beautycaremain
...    Beauty Accessories &=beauty_accessories_and_beautycaremain   
...    Hair Care=hair_care_beautycaremain
...    Facial Skin Care=facial_skin_care_beautycaremain

# Screenshot Flag
${ENABLE_ALL_SCREENSHOTS}               ${False}