local assets =
{
    Asset("ANIM", "anim/nutrientpaste.zip"),
}

local prefabs =
{
    "slugling",
}

local function hatch(inst)
    --doesn't spawn sluglings if parent doesn't exist or is dead 
    if not inst.parent_slug or inst.parent_slug.components.health:IsDead() then 
        inst:Remove() 
        return 
    end 

    local hatched_slug = SpawnPrefab("slugling")
    hatched_slug.Transform:SetPosition(inst:GetPosition():Get())
    hatched_slug.sg:GoToState("hatch_pre")

    --sets up follower in parent slug 
    inst.parent_slug.components.leader:AddFollower(hatched_slug)

    inst:DoTaskInTime(1, function(inst) --remove task is delayed to make the animation smoother
        inst:Remove() 
    end)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("nutrientpaste")
    inst.AnimState:SetBuild("nutrientpaste")
    inst.AnimState:PlayAnimation("idle", true)

    MakeInventoryPhysics(inst)

    inst.parent_slug = nil --this should be changed by the parent slug itself
    inst:DoTaskInTime(2, hatch)

    return inst 
end

return Prefab("slugling_egg", fn, assets)
    