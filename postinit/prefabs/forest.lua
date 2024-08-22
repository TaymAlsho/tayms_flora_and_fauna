AddPrefabPostInit("forest", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return 
    end 
    
    inst:AddComponent("gardenslug_spawner_manager")
end)