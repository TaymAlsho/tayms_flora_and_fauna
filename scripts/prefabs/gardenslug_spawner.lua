--spread throughout the world during worldgen to register places to spawn gardenslugs by the gardenslug manager component

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    TheWorld:PushEvent("taym_registergardenslug", inst)

    return inst
end

return Prefab("gardenslug_spawner", fn)