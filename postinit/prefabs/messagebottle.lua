--gives each message bottle a chance to reveal gardenslugs rather than whatever they would have revealed normally

local function newgetrevealtargetpos(inst, doer)
    if GLOBAL.TheWorld.components.gardenslug_spawner_manager == nil then 
        print("Could not find gardenslug_spawner_manager for a messagebottle")
        return 
    end 

    local pos, reason = GLOBAL.TheWorld.components.gardenslug_spawner_manager:SpawnGardenSlug()
    return pos, reason 
end 

AddPrefabPostInit("messagebottle", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return 
    end 

    --easier to just turn back here if we want the bottle to be normal since we need to make sure prereveal and mapspotrevealer do the same thing
    if math.random() >= GetModConfigData("gardenslug_bottle_chance") then 
        return 
    end 

    local oldgetrevealtargetpos = inst.components.mapspotrevealer.gettargetfn
    inst.components.mapspotrevealer:SetGetTargetFn(function(inst, doer) 
        if GLOBAL.TheWorld.components.gardenslug_spawner_manager == nil then 
            print("Could not find gardenslug_spawner_manager for a messagebottle. Using default bottle reveal instead.")
            return oldgetrevealtargetpos(inst, doer)
        end 

        --don't spawn a gardenslug if the player hasn't found pearl yet 
        if GLOBAL.TheWorld.components.messagebottlemanager ~= nil and 
           not GLOBAL.TheWorld.components.messagebottlemanager:GetPlayerHasFoundHermit(doer) then 
            return oldgetrevealtargetpos(inst, doer)
        end 

        --only spawn a gardenslug if there aren't too many gardenslugs in the world 
        if GLOBAL.TheWorld.components.gardenslug_spawner_manager:GetGardenSlugAmount() < GetModConfigData("gardenslug_max") then 
            return newgetrevealtargetpos(inst, doer) 
        end

        --otherwise do whatever reveal it would've done normally
        return oldgetrevealtargetpos(inst, doer)
    end)

    local oldprereveal = inst.components.mapspotrevealer.prerevealfn 
    inst.components.mapspotrevealer:SetPreRevealFn(function(inst, doer)
        if GLOBAL.TheWorld.components.gardenslug_spawner_manager == nil then 
            print("Could not find gardenslug_spawner_manager for a messagebottle. Using default bottle reveal instead.")
            return oldprereveal(inst, doer)
        end 

        --don't spawn a gardenslug if the player hasn't found pearl yet 
        if GLOBAL.TheWorld.components.messagebottlemanager ~= nil and 
           not (GLOBAL.TheWorld.components.messagebottlemanager:GetPlayerHasUsedABottle(doer) 
           or GLOBAL.TheWorld.components.messagebottlemanager:GetPlayerHasFoundHermit(doer)) then 
            return oldprereveal(inst, doer)
        end 

        --only spawn a gardenslug if there aren't too many gardenslugs in the world 
        if GLOBAL.TheWorld.components.gardenslug_spawner_manager:GetGardenSlugAmount() < GetModConfigData("gardenslug_max") then 
            return true 
        end

        --otherwise do whatever reveal it would've done normally
        return oldprereveal(inst, doer)
    end)
end)