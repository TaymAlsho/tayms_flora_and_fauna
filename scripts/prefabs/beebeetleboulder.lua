local assets =
{
    Asset("ANIM", "anim/beebeetleboulder.zip"),
    Asset("ANIM", "anim/hibeebeetleboulder.zip"),
}

local prefabs =
{
    "honey",
    "honeycomb",
    "fish",
}

if KnownModIndex:IsModEnabled("workshop-1289779251") then 
    table.insert(prefabs, "cherry_honey")
    table.insert(prefabs, "cherrygem")
end 

SetSharedLootTable("beebeetleboulder",
{
    { "honey",          1.00},
    { "honey",          1.00},
    { "honey",          1.00},
    { "honey",          1.00},
    { "honey",          1.00},
    { "honey",          1.00},
    { "honey",          0.50},
    { "honey",          0.50},
    { "honey",          0.50},
    { "honey",          0.50},    

    { "fish",           0.30}, 
    { "honeycomb",      0.10},   
})

SetSharedLootTable("hibeebeetleboulder",
{
    { "cherry_honey",          1.00},
    { "cherry_honey",          1.00},
    { "cherry_honey",          1.00},
    { "cherry_honey",          1.00},
    { "cherry_honey",          0.50}, 
    { "cherry_honey",          0.50}, 

    { "fish",                  0.30}, 
    { "cherrygem",             0.10},   
})

local PHYSICS_RADIUS = .75

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", inst.animname, "swap_body")
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function OnPicked(inst, picker)
    inst.components.lootdropper:DropLoot(inst:GetPosition())
end

local function commonfn(name)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("beebeetleboulder")
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("heavy")
    inst:AddTag("boulder")

    MakeHeavyObstaclePhysics(inst, PHYSICS_RADIUS)
    inst:SetPhysicsRadiusOverride(PHYSICS_RADIUS)

    MakeInventoryFloatable(inst, "med", 0.3, 1)
    inst:DoTaskInTime(0, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.animname = name 

    --
    inst:AddComponent("heavyobstaclephysics")
    inst.components.heavyobstaclephysics:SetRadius(PHYSICS_RADIUS)

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable(name)

    --
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    --
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

    --
    inst:AddComponent("pickable")
	inst.components.pickable.onpickedfn = OnPicked
	inst.components.pickable.remove_when_picked = true
	inst.components.pickable.canbepicked = true

    --
    inst:AddComponent("symbolswapdata")
	inst.components.symbolswapdata:SetData(name, "swap_body")

    return inst
end

local function fn() 
    return commonfn("beebeetleboulder")
end 

local function cherry_fn()
    if not KnownModIndex:IsModEnabled("workshop-1289779251") then 
        return commonfn("beebeetleboulder")
    end 
        
    return commonfn("hibeebeetleboulder")
end 


return Prefab("beebeetleboulder", fn, assets, prefabs),
       Prefab("hibeebeetleboulder", cherry_fn, assets, prefabs)