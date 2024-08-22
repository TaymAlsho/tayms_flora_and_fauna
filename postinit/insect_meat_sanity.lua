--[[ this file adds unique sanity gains and losses for every character when eating foods with the "insectmeat" tag
LOVE_CHARACTERS have 10 sanity added to the default value and always get at least 10 sanity from insect foods unless the food has the tag 'intolerableinsect'
LIKE_CHARACTERS have 5 sanity added to the default value and always get at least 5 sanity from insect foods unless the food has the tag 'intolerableinsect'
DEFAULT_CHARACTERS simply use the default values found in init_tuning
DISLIKE_CHARACTERS have 5 sanity subtracted from the default value unless the food has the tag "tolerableinsect"
HATE_CHARACTERS refuse to eat insect meat at all unless the food has the tag "tolerableinsect"

if you'd like to make your own insect meat food, add the 'intolerableinsect' tag to foods like 'raw insect meat' which no one should like
or add 'tolerableinsect' to foods that every character should be able get sanity from like 'croakuembouche'
]]

--doesn't include wurt; she shouldn't be allowed to eat meat anyways
local ALL_CHARACTERS = {wilson = true, willow = true, wolfgang = true, wendy = true, 
wx78 = true, wickerbottom = true, woodie = true, waxwell = true, wathgrithr = true, webber = true, 
warly = true, winona = true, wortox = true, wormwood = true, walter = true, wanda = true, wes = true}

local LOVE_CHARACTERS = {wickerbottom = true, wanda = true,} 
local LIKE_CHARACTERS = {webber = true, wormwood = true, walter = true, wx78 = true, wendy = true,} 
local DEFAULT_CHARACTERS = {wilson = true, winona = true, warly = true} 
local DISLIKE_CHARACTERS = {wolfgang = true, willow = true, waxwell = true, wortox = true,} 
local HATE_CHARACTERS = {woodie = true, wathgrithr = true, wes = true} 

if GLOBAL.KnownModIndex:IsModEnabled("workshop-2039181790") then 
    ALL_CHARACTERS.wathom = true 
    LIKE_CHARACTERS.wathom = true 

    ALL_CHARACTERS.winkie = true
    LOVE_CHARACTERS.winkie = true 

    ALL_CHARACTERS.wixie = true 
    DISLIKE_CHARACTERS.wixie = true 
end 

if GLOBAL.KnownModIndex:IsModEnabled("workshop-1289779251") then 
    ALL_CHARACTERS.wirlywings = true 
    HATE_CHARACTERS.wirlywings = true 
end 

for character, _ in pairs(ALL_CHARACTERS) do 
    if LOVE_CHARACTERS[character] then
        AddPrefabPostInit(tostring(character), function(inst)
            if not GLOBAL.TheWorld.ismastersim then --do nothing to the client replica components
                return 
            end 

            --save old Eat function and call it after temporarily modifying the food's sanity values 
            local oldEat = inst.components.eater.Eat

            inst.components.eater.Eat = function(self, food)   
                local edible = food.components.edible 

                if edible and food:HasTag("insectmeat") then
                    local original_sanity = edible.sanityvalue 
                    local new_sanity = original_sanity + 10

                    if new_sanity < 10 and not food:HasTag("intolerableinsect") then 
                        edible.sanityvalue = 10
                    else 
                        edible.sanityvalue = new_sanity
                    end 
                end 

                --get the food values with the updated food stats
                local EatValue = oldEat(self, food)
                
                --reset food values if changes were made
                if food:IsValid() and original_sanity ~= nil then 
                    edible.sanityvalue = original_sanity 
                end 

                return EatValue 
            end 
        end)

    elseif LIKE_CHARACTERS[character] then 
        AddPrefabPostInit(tostring(character), function(inst)
            if not GLOBAL.TheWorld.ismastersim then --do nothing to the client replica components
                return 
            end 

            --save old Eat function and call it after temporarily modifying the food's sanity values 
            local oldEat = inst.components.eater.Eat

            inst.components.eater.Eat = function(self, food)   
                local edible = food.components.edible 

                if edible and food:HasTag("insectmeat") then
                    local original_sanity = edible.sanityvalue 
                    local new_sanity = original_sanity + 5

                    if new_sanity < 5 and not food:HasTag("intolerableinsect") then 
                        edible.sanityvalue = 5
                    else 
                        edible.sanityvalue = new_sanity
                    end 
                end 

                --get the food values with the updated food stats
                local EatValue = oldEat(self, food)
                
                --reset food values if changes were made
                if food:IsValid() and original_sanity ~= nil then 
                    edible.sanityvalue = original_sanity 
                end 

                return EatValue 
            end 
        end)

    --elseif DEFAULT_CHARACTERS[character] then 
        --just use tuning values 

    elseif DISLIKE_CHARACTERS[character] then 
        AddPrefabPostInit(tostring(character), function(inst)
            if not GLOBAL.TheWorld.ismastersim then --do nothing to the client replica components
                return 
            end 

            --save old Eat function and call it after temporarily modifying the food's sanity values 
            local oldEat = inst.components.eater.Eat

            inst.components.eater.Eat = function(self, food)   
                local edible = food.components.edible 

                if edible and food:HasTag("insectmeat") and not food:HasTag("tolerableinsect") then
                    local original_sanity = edible.sanityvalue 
                    edible.sanityvalue = original_sanity - 5
                end 

                --get the food values with the updated food stats
                local EatValue = oldEat(self, food)
                
                --reset food values if changes were made
                if food:IsValid() and original_sanity ~= nil then 
                    edible.sanityvalue = original_sanity 
                end 

                return EatValue 
            end 
        end)

    elseif HATE_CHARACTERS[character] then
        AddPrefabPostInit(tostring(character), function(inst)
            if not GLOBAL.TheWorld.ismastersim then --do nothing to the client replica components
                return 
            end 
            
            --save old CanEat function and call it after we do our own checks 
            local oldPrefersToEat = inst.components.eater.PrefersToEat

            inst.components.eater.PrefersToEat = function(self, food)
                if food:HasTag("insectmeat") and not food:HasTag("tolerableinsect") then 
                    return false 
                end
                
                if oldPrefersToEat ~= nil then 
                    return oldPrefersToEat(self, food)
                end 

                return true
            end
        end)
    end 
end 

--throwing this in here for warly so that he isn't allowed to eat nutrient paste 
AddPrefabPostInit("warly", function(inst)
    if not GLOBAL.TheWorld.ismastersim then --do nothing to the client replica components
        return 
    end 
    local oldPrefersToEat = inst.components.eater.PrefersToEat
    inst.components.eater.PrefersToEat = function(self, food)
        if food:HasTag("nutrientpaste") then 
            return false 
        end
        
        if oldPrefersToEat ~= nil then 
            return oldPrefersToEat(self, food)
        end 

        return true 
    end 
end)