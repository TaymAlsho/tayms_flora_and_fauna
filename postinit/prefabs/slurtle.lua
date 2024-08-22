AddPrefabPostInit("slurtle", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return 
    end 

    if inst.components.lootdropper ~= nil then 
        inst.components.lootdropper:AddChanceLoot("insect_meat_raw", 0.5)
    end 
end)

AddPrefabPostInit("snurtle", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return 
    end 

    if inst.components.lootdropper ~= nil then 
        inst.components.lootdropper:AddChanceLoot("insect_meat_raw", 1)
    end 
end)
