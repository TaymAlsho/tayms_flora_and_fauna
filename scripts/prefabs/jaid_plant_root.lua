require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/jaid_plant_root.zip"),

    Asset("ATLAS", "images/inventoryimages/jaid_plant_root.xml"),
    Asset("IMAGE", "images/inventoryimages/jaid_plant_root.tex"),
}

local function ondeploy(inst, pt, deployer)
    local plant = SpawnPrefab("jaid_plant_plant")
    if plant ~= nil then
        plant.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
        --plant.components.pickable:OnTransplant() -- jaid plant does not suffer from transplant sickness
		plant.components.pickable:MakeEmpty()
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("jaid_plant_root")
    inst.AnimState:SetBuild("jaid_plant_root")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst)

    inst:AddTag("deployedplant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/jaid_plant_root.xml"
    inst.components.inventoryitem.imagename = "jaid_plant_root"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)
    inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)

    MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    ---------------------
    return inst
end

return Prefab("jaid_plant_root", fn, assets),
		MakePlacer("jaid_plant_root_placer", "jaid_plant_plant", "jaid_plant_plant", "idle_grown", false, false, false, nil, nil, nil, nil, 2)
