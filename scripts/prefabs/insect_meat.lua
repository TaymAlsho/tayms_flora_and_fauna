local assets =
{
    Asset("ANIM", "anim/insect_meat.zip"),

    Asset("ATLAS", "images/inventoryimages/insect_meat_raw_inv.xml"),
    Asset("IMAGE", "images/inventoryimages/insect_meat_raw_inv.tex"),

    Asset("ATLAS", "images/inventoryimages/insect_meat_cooked_inv.xml"),
    Asset("IMAGE", "images/inventoryimages/insect_meat_cooked_inv.tex"),

    Asset("ATLAS", "images/inventoryimages/insect_meat_dried_inv.xml"),
    Asset("IMAGE", "images/inventoryimages/insect_meat_dried_inv.tex"),
}

local prefabs =
{
    "spoiled_food",
}

local function OnSpawnedFromHaunt(inst, data)
    Launch(inst, data.haunter, TUNING.LAUNCH_SPEED_SMALL)
end

local function insect_meat_raw(inst)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("insect_meat")
    inst.AnimState:SetBuild("insect_meat")
    inst.AnimState:PlayAnimation("idle_raw")

    inst:AddTag("meat")
    inst:AddTag("insectmeat")
    inst:AddTag("intolerableinsect")
    inst:AddTag("dryable")
    inst:AddTag("cookable")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.INSECT_MEAT_RAW_HEALING
    inst.components.edible.hungervalue = TUNING.INSECT_MEAT_RAW_CALORIES
    inst.components.edible.sanityvalue = TUNING.INSECT_MEAT_RAW_SANITY

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    inst.components.inventoryitem.atlasname = "images/inventoryimages/insect_meat_raw_inv.xml"
    inst.components.inventoryitem.imagename = "insect_meat_raw_inv"

    --
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    --
    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("insect_meat_dried")
    inst.components.dryable:SetDryTime(TUNING.DRY_MED)
	inst.components.dryable:SetBuildFile("insect_meat")
    inst.components.dryable:SetDriedBuildFile("insect_meat")

    --
    inst:AddComponent("cookable")
    inst.components.cookable.product = "insect_meat_cooked"

    --
    MakeHauntableLaunchAndPerish(inst)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    return inst
end

local function insect_meat_cooked(inst)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("insect_meat")
    inst.AnimState:SetBuild("insect_meat")
    inst.AnimState:PlayAnimation("idle_cooked")

    inst:AddTag("meat")
    inst:AddTag("insectmeat")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.INSECT_MEAT_COOKED_HEALING
    inst.components.edible.hungervalue = TUNING.INSECT_MEAT_COOKED_CALORIES
    inst.components.edible.sanityvalue = TUNING.INSECT_MEAT_COOKED_SANITY

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    inst.components.inventoryitem.atlasname = "images/inventoryimages/insect_meat_cooked_inv.xml"
    inst.components.inventoryitem.imagename = "insect_meat_cooked_inv"

    --
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    --
    MakeHauntableLaunchAndPerish(inst)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    return inst
end

local function insect_meat_dried(inst)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("insect_meat")
    inst.AnimState:SetBuild("insect_meat")
    inst.AnimState:PlayAnimation("idle_dried")

    inst:AddTag("meat")
    inst:AddTag("insectmeat")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst:AddComponent("edible")
    inst.components.edible.ismeat = true
    inst.components.edible.foodtype = FOODTYPE.MEAT
    inst.components.edible.healthvalue = TUNING.INSECT_MEAT_DRIED_HEALING
    inst.components.edible.hungervalue = TUNING.INSECT_MEAT_DRIED_CALORIES
    inst.components.edible.sanityvalue = TUNING.INSECT_MEAT_DRIED_SANITY

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("inventoryitem")
    inst:AddComponent("stackable")
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
    inst.components.inventoryitem.atlasname = "images/inventoryimages/insect_meat_dried_inv.xml"
    inst.components.inventoryitem.imagename = "insect_meat_dried_inv"

    --
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    --
    MakeHauntableLaunchAndPerish(inst)
    inst:ListenForEvent("spawnedfromhaunt", OnSpawnedFromHaunt)

    return inst
end

return Prefab("insect_meat_raw", insect_meat_raw, assets),
        Prefab("insect_meat_cooked", insect_meat_cooked, assets),
        Prefab("insect_meat_dried", insect_meat_dried, assets)