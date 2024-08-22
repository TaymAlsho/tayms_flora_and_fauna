local brain = require "brains/gardenslug_brain"

local assets =
{
    Asset("ANIM", "anim/gardenslug.zip"),

    Asset("IMAGE", "images/minimapimages/gardenslug_minimap.tex"),
}

local prefabs =
{
    "dug_sapling",
    "dug_grass",
    "jaid_plant_root",
    "insect_meat_raw",
    "slugling_egg",
}

SetSharedLootTable('gardenslug',
{
    {"jaid_plant_root",  1.0},
    {"jaid_plant_root",  1.0},

    {"insect_meat_raw",  1.0},
    {"insect_meat_raw",  1.0},
    {"insect_meat_raw",  1.0},
    {"insect_meat_raw",  1.0},

    {"dug_sapling",  0.5},
    {"dug_grass",  0.5},
})

local spawned_slugling
local slugling_count

local function SlugDebug(inst, occasion)
    print("TFF GARDEN SLUG "..occasion)
    print(inst.components.leader:GetDebugString())
    print(inst.components.periodicspawner:GetDebugString())
end

local function OnSpawn(inst)
    --SlugDebug(inst, "SHED")
    if math.random() < 0.5 then 
        inst.components.periodicspawner:SetPrefab("dug_sapling")
    else 
        inst.components.periodicspawner:SetPrefab("dug_grass")
    end
end

local function SpawnSlugling(inst)
    spawned_slugling = SpawnPrefab("slugling_egg")
    spawned_slugling.parent_slug = inst --cant set up follower/leader relationship here: spawned_slugling is replaced with another prefab
    --follower/leader relationship is instead set up when the egg hatches using parent_slug

    spawned_slugling.Transform:SetPosition(inst:GetPosition():Get())
    inst.components.lootdropper:FlingItem(spawned_slugling)
end

local function OnAttacked(inst, data)
    --SlugDebug(inst, "ATTACKED")
    if not inst.components.timer:TimerExists("Spawneggs") then 
        slugling_count = inst.components.leader:CountFollowers()

        for i = slugling_count, TUNING.GARDENSLUG_MAX_SLUGLINGS - 1 do --only GARDENSLUG_MAX_SLUGLINGS should be alive at any given time 
            inst:DoTaskInTime(math.random(), SpawnSlugling)
        end

        inst.components.timer:StopTimer("Spawneggs")
		inst.components.timer:StartTimer("Spawneggs", TUNING.GARDENSLUG_SPAWNEGG_COOLDOWN)
    end 
end

local function OnDeath(inst)
    --SlugDebug(inst, "DEATH")
    TheWorld:PushEvent("taym_gardenslugkilled") --caught by gardenslug manager
    for follower, _ in pairs(inst.components.leader.followers) do
        if follower.components and follower.components.health then 
            follower.components.health:Kill()
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
    
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("gardenslug_minimap.tex")

    MakeCharacterPhysics(inst, 100, .75)

    --
    inst.DynamicShadow:SetSize(5, 3)
    inst.Transform:SetFourFaced()

    --
    inst:AddTag("animal")
    inst:AddTag("largecreature")

    --
    inst.AnimState:SetBank("gardenslug")
    inst.AnimState:SetBuild("gardenslug")
    inst.AnimState:PlayAnimation("idle_loop", true)

    --
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("death", OnDeath)

    --
    inst:AddComponent("leader")
    --
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.GARDENSLUG_HEALTH)

    --
    inst:AddComponent("lootdropper")
    inst.components.lootdropper.min_speed = 2
    inst.components.lootdropper.max_speed = 4
    inst.components.lootdropper:SetChanceLootTable("gardenslug")

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawn)
    OnSpawn(inst) -- to initially set up spawn prefab 
    inst.components.periodicspawner:SetRandomTimes(TUNING.GARDENSLUG_DROP_TIME, TUNING.GARDENSLUG_DROP_TIME_VARIANCE, true)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(8)
    inst.components.periodicspawner:Start()

    --
    inst:AddComponent("timer")

    --
    MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")

    --
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 3
    --

    TheWorld:PushEvent("taym_gardenslugcreated") --caught by gardenslug manager

    --
    inst:SetBrain(brain)
    inst:SetStateGraph("SGgardenslug")
    return inst
end

return Prefab("gardenslug", fn, assets)