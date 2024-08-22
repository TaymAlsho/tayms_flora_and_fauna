local assets =
{
    Asset("ANIM", "anim/jaid_plant_plant.zip"),
    Asset("SOUND", "sound/common.fsb"),

    Asset("IMAGE", "images/minimapimages/jaid_plant_minimap.tex"),
}


local prefabs =
{
    "plantaid",
    "jaid_plant_root",
}

local function onpickedfn(inst)
    inst.AnimState:PlayAnimation("pick")
    inst.AnimState:PushAnimation("idle_empty", true)
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle_grown", true)
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("idle_empty", true)
end

local function CheckBeached(inst)
    inst._checkgroundtask = nil
    local x, y, z = inst.Transform:GetWorldPosition()
    if inst:GetCurrentPlatform() ~= nil or TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
        if inst.components.pickable ~= nil then
            inst.components.pickable:Pick(TheWorld)
        end
        inst:Remove()
        local beached = SpawnPrefab("jaid_plant_root")
        beached.Transform:SetPosition(x, y, z)
    end
end

local function OnCollide(inst, other)
    if inst._checkgroundtask == nil then
        -- This collision callback is called very fast so only do the checks after some time in a staggered method.
        inst._checkgroundtask = inst:DoTaskInTime(1 + math.random(), CheckBeached)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("jaid_plant_minimap.tex")

    MakeInventoryPhysics(inst, nil, 0.7)

    inst.AnimState:SetBank("jaid_plant_plant")
    inst.AnimState:SetBuild("jaid_plant_plant")
    inst.AnimState:PushAnimation("idle_grown", true)
	inst.AnimState:SetFinalOffset(1)

    inst:AddTag("jaid_plant")

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
    inst.components.pickable:SetUp("plantaid", TUNING.JAID_PLANT_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn

    --
    inst:AddComponent("inspectable")

    --
    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
    --
    inst.Physics:SetCollisionCallback(OnCollide)
    inst:DoTaskInTime(1 + math.random(), CheckBeached) -- does not need to be immediately done, stagger over time

    return inst
end

return Prefab("jaid_plant_plant", fn, assets, prefabs)