local assets = {
    Asset("ANIM", "anim/clockwork_tower.zip"),
}

local prefabs =
{
    "gears",
    "trinket_6",
}

SetSharedLootTable('clockwork_tower',
{
    {"gears",  1.0},
    {"trinket_6",  1.0},
    {"trinket_6",  1.0},
})

local RETARGET_MUST_TAGS = { "_combat"}
local RETARGET_ONEOF_TAGS = { "character", "monster" }
local RETARGET_CANT_TAGS = { "INLIMBO" }

local function Retarget(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")
    local function IsValidTarget(guy)
        return not guy.components.health:IsDead()
            and inst.components.combat:CanTarget(guy)
    end
    
    return not (homePos ~= nil and
                inst:GetDistanceSqToPoint(homePos:Get()) >= TUNING.CLOCKWORK_TOWER_TARGET_DIST * TUNING.CLOCKWORK_TOWER_TARGET_DIST)
        and FindEntity(
            inst,
            TUNING.CLOCKWORK_TOWER_TARGET_DIST,
            IsValidTarget,
            RETARGET_MUST_TAGS,
            RETARGET_CANT_TAGS,
            RETARGET_ONEOF_TAGS
        )
        or nil 
end

local function KeepTarget(inst, target)
    local homePos = inst.components.knownlocations:GetLocation("home")
    return homePos ~= nil and target:GetDistanceSqToPoint(homePos:Get()) < TUNING.CLOCKWORK_TOWER_MAX_CHASEAWAY_DIST
end

local function ExplosionSwitches(inst)
    -- reveals the corresponding red light based on the amount of times hit 
    for i = 1, 4 do 
        if i == inst.switch_counter then 
            inst.AnimState:Show(tostring(i).."red")
            inst.SoundEmitter:PlaySound("dontstarve/common/together/spot_light/electricity")
        end
    end

    -- forces the special attack + starts its cooldown
    if inst.switch_counter > inst.max_switches then
        inst.switch_counter = 0 
        inst.sg:GoToState("startexplode")
        inst.components.timer:StopTimer("TripleGroundPound")
		inst.components.timer:StartTimer("TripleGroundPound", TUNING.CLOCKWORK_TOWER_EXPLODE_COOLDOWN)
    end

    -- turns the red lights off
    if inst.switch_counter == 0 then 
        for i = 1, 4 do 
            inst.AnimState:Hide(tostring(i).."red")
        end
    end
end 

local function OnAttacked(inst, data)
    local attacker = data ~= nil and data.attacker or nil

    if attacker == nil then
        return
    elseif attacker:HasTag("chess") then
        return
    elseif attacker:HasTag("player") then 
        -- sets last attacker to the player for map reveal purposes
        inst.last_attacker = attacker

        if not inst.components.timer:TimerExists("TripleGroundPound") then
            inst.switch_counter = inst.switch_counter + 1 
            ExplosionSwitches(inst)
        end
    end

    inst.components.combat:SetTarget(attacker)
end

local function SetHomePosition(inst)
    inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()      
    inst.entity:AddAnimState()     
    inst.entity:AddSoundEmitter()   
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .5)

    inst.DynamicShadow:SetSize(3, 2)
    inst.Transform:SetFourFaced()
 
    --
    inst.AnimState:SetBank("clockwork_tower")
    inst.AnimState:SetBuild("clockwork_tower")
    inst.AnimState:PlayAnimation("idle_loop")

    --
    inst:AddTag("chess")
    inst:AddTag("hostile")
    inst:AddTag("monster")
    inst:AddTag("clockworktower")
    
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.explosionswitches = ExplosionSwitches
    inst.pawn_angle = 2*math.pi*math.random() --decide the initial pawn angle on creation rather than on the fly
    --this is important since it makes it much easier to predict where they'll spawn to dodge accordingly
    
    --
    inst.last_attacker = nil 
    inst.switch_counter = 0
    inst.max_switches = 4
    ExplosionSwitches(inst) --to initially hide all red lights

    --
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 2
    inst:SetStateGraph("SGclockwork_tower")

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CLOCKWORK_TOWER_HEALTH)

    -- pawn explosions can damage the clockwork tower! to compensate, health is slightly raised
    local taymid = KnownModIndex:GetModActualName("Taym's Flora and Fauna")
    if KnownModIndex:IsModEnabled("workshop-2039181790") and GetModConfigData("clockwork_tower_pawns", taymid) then 
        inst.components.health:SetMaxHealth(TUNING.CLOCKWORK_TOWER_HEALTH + 500)
    end 

    --
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetDefaultDamage(TUNING.CLOCKWORK_TOWER_DAMAGE)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    --
    inst:AddComponent("groundpounder")
	inst.components.groundpounder:UseRingMode()
	inst.components.groundpounder.damageRings = 1
    inst.components.groundpounder.destructionRings = 1
	inst.components.groundpounder.platformPushingRings = 1
    inst.components.groundpounder.numRings = 1
	inst.components.groundpounder.radiusStepDistance = 1
	inst.components.groundpounder.ringWidth = 4
    inst:AddComponent("timer")
    table.insert(inst.components.groundpounder.noTags, "uncompromising_pawn") --stops clockwork tower from hurting spawned pawns

    --
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('clockwork_tower')

    --
    inst:SetBrain(require("brains/clockwork_tower_brain"))

    --
    inst:AddComponent("knownlocations")
    inst:DoTaskInTime(0, SetHomePosition) --set home after position has been set 

    --
    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("clockwork_tower", fn, assets)