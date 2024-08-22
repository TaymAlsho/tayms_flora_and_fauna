local brain = require "brains/slugling_brain"

local assets =
{
    Asset("ANIM", "anim/slugling.zip"),
    Asset("ANIM", "anim/grassgecko.zip"),
}

local prefabs =
{
    "insect_meat_raw",
}

SetSharedLootTable('slugling',
{
    {"insect_meat_raw",  0.05},
})

local RETARGET_MUST_TAGS = { "_combat"}
local RETARGET_ONEOF_TAGS = { "character"}
local RETARGET_CANT_TAGS = { "INLIMBO" }

local function OnAttacked(inst, data)
    local attacker = data ~= nil and data.attacker or nil

    if attacker == nil then
        return
    end

    inst.components.combat:SetTarget(attacker)
end

local function Retarget(inst)
    local function IsValidTarget(guy)
        return not guy.components.health:IsDead()
            and inst.components.combat:CanTarget(guy)
    end
    
    return 
        FindEntity(
            inst,
            TUNING.SLUGLING_TARGET_DIST,
            IsValidTarget,
            RETARGET_MUST_TAGS,
            RETARGET_CANT_TAGS,
            RETARGET_ONEOF_TAGS
        )
        or nil 
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1.25, 0.5)

    --
    inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetFourFaced()

    --
    inst:AddTag("animal")
    inst:AddTag("smallcreature")

    --
    inst.AnimState:SetBank("slugling")
    inst.AnimState:SetBuild("slugling")
    inst.AnimState:PlayAnimation("idle_loop", true)

    --
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    --
    MakeSmallBurnableCharacter(inst, "body")
    MakeTinyFreezableCharacter(inst, "body")

    --
    inst:AddComponent("follower")

    --
    inst:AddComponent("drownable")

    --
    inst:AddComponent("sleeper")

    --
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SLUGLING_HEALTH)

    --
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetDefaultDamage(TUNING.SLUGLING_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SLUGLING_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetRange(2)
    inst:ListenForEvent("attacked", OnAttacked)

    --
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("slugling")

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("timer")

    --
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 6
    inst.components.locomotor.runspeed = 6

    --
    inst:SetBrain(brain)
    inst:SetStateGraph("SGslugling")

    return inst
end

return Prefab("slugling", fn, assets)