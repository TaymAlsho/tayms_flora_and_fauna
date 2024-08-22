--this saves pawn speed/damage/drops and reapplies it when they are loaded again 
--need this to save the changes made in SGclockwork_tower's NerfPawn, or they will get overwritten if the player disconnects before they explode

local function NewOnSave(inst, data)
    data.pawndamage = inst.components.explosive.explosivedamage
    data.pawnrunspeed = inst.components.locomotor.runspeed 
    data.pawnwalkspeed = inst.components.locomotor.walkspeed 
    data.pawnloot = inst.components.lootdropper.chanceloottable ~= nil 
end 

local function NewOnLoad(inst, data)
    if data ~= nil then 
        if data.pawndamage and inst.components and inst.components.explosive then 
            inst.components.explosive.explosivedamage = data.pawndamage
        end 

        if data.pawnrunspeed and data.pawnwalkspeed and inst.components and inst.components.locomotor then 
            inst.components.locomotor.runspeed = data.pawnrunspeed 
            inst.components.locomotor.walkspeed = data.pawnwalkspeed 
        end 

        if data.pawnloot == false and inst.components and inst.components.lootdropper then 
            inst.components.lootdropper:SetChanceLootTable(nil)
        end 
    end 
end 

if GLOBAL.KnownModIndex:IsModEnabled("workshop-2039181790") then 
    AddPrefabPostInit("um_pawn_nightmare", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return 
        end 

        --pawn doesn't save and load right now, but lets future proof it anyways
        local oldOnSave = inst.OnSave
        local oldOnLoad = inst.OnLoad 

        inst.OnSave = function(inst, data)
            if oldOnSave ~= nil then 
                oldOnSave(inst, data)
            end 
            NewOnSave(inst, data) 
        end 

        inst.OnLoad = function(inst, data)
            if oldOnLoad ~= nil then 
                oldOnLoad(inst, data)
            end 
            NewOnLoad(inst, data) 
        end 
    end)
end 
