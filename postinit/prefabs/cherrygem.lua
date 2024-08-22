--adding a tag to make trading with beebeetleden's easier
if GLOBAL.KnownModIndex:IsModEnabled("workshop-1289779251") then 
    AddPrefabPostInit("cherrygem", function(inst)
        inst:AddTag("cherrygem")
    end)
end 