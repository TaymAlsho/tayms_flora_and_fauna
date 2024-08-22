local prefabs =
{
    "beebeetle",
    "killerbeebeetle",
    "hibeebeetle",
    "honey",
    "honeycomb",
    "rocks",
    "beebeetleboulder",
    "hibeebeetleboulder",
}

local assets =
{
    Asset("ANIM", "anim/beebeetleden.zip"),
}

SetSharedLootTable("beebeetleden",
{
    {"rocks",       1.00},
    {"rocks",       1.00},
    {"rocks",       1.00},
    {"rocks",       0.50},

    {"honey",       1.00},
    {"honey",       1.00},
    {"honey",       1.00},
    {"honey",       1.00},
    {"honey",       0.50},
    {"honey",       0.50},
})

local function UpdateAnim(inst)
    if not inst.components.pickable then 
        return 
    end 

    if inst.cherried then 
        if inst.components.pickable:CanBePicked() then 
            inst.AnimState:PlayAnimation("cherry_idle_full")
        else
            inst.AnimState:PlayAnimation("cherry_idle")
        end 
    else 
        if inst.components.pickable:CanBePicked() then 
            inst.AnimState:PlayAnimation("idle_full")
        else
            inst.AnimState:PlayAnimation("idle")
        end 
    end 
end 

local function OnCherried(inst) 
    inst.cherried = true 
    inst.angrychild = "hibeebeetle"

    if KnownModIndex:IsModEnabled("workshop-1289779251") then 
        inst.components.lootdropper:AddChanceLoot("cherrygem", 1)
    end

    if inst.components.childspawner then 
        inst.components.childspawner.childname = "hibeebeetle"
        inst.components.childspawner.emergencychildname = "hibeebeetle"
    end 

    if inst.components.pickable then 
        inst.components.pickable:SetUp("hibeebeetleboulder", TUNING.BEEBEETLEDEN_HARVEST_TIME)
    end 

    UpdateAnim(inst)
end 

local function ShouldAcceptItem(inst, item)
    return item:HasTag("cherrygem")
end 

local function OnWork(inst, worker, workleft)
    if workleft > 0 then 
        if inst.components.childspawner ~= nil then
            inst.components.childspawner:ReleaseAllChildren(worker, inst.angrychild)
        end

        return 
    end 

    SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function OnPick(inst, picker, loot)
    if inst.components.childspawner ~= nil and
        not (picker ~= nil and picker.components.skilltreeupdater ~= nil and picker.components.skilltreeupdater:IsActivated("wormwood_bugs"))
    then
        inst.components.childspawner:ReleaseAllChildren(picker, inst.angrychild)
    end

    inst.components.pickable.canbepicked = false --doing this a bit before it normally happens so that the anim gets updated properly
    UpdateAnim(inst)
end

local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics

    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * COLLISION_DAMAGE_SCALE / boat_physics.max_velocity + 0.5)

        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.BEEBEETLEDEN_MINE)
    end
end

local function StartSpawning(inst)
    if inst.components.childspawner ~= nil and not TheWorld.state.iswinter then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnIsDay(inst, isday)
    if isday then
        StartSpawning(inst)
    else
        StopSpawning(inst)
    end
end

local function OnInit(inst)
    inst:WatchWorldState("isday", OnIsDay)
    OnIsDay(inst, TheWorld.state.isday)
end

local function CLIENT_ForceFloaterUpdate(inst)
    inst.components.floater:OnLandedServer()
end

local function OnSave(inst, data)
    data.cherried = inst.cherried 
end 

local function OnLoad(inst, data)
    if data and data.cherried == true then 
        OnCherried(inst)
    else 
        UpdateAnim(inst)
    end 
end 

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst:SetPhysicsRadiusOverride(2.35)
    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst.MiniMapEntity:SetIcon("beehive.png")

    inst.AnimState:SetBank("beebeetleden")
    inst.AnimState:SetBuild("beebeetleden")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("structure")

    MakeInventoryFloatable(inst, "med", 0.1, {1.1, 0.9, 1.1})
    inst.components.floater:SetIsObstacle()
    inst.components.floater.bob_percent = 0

    local land_time = POPULATING and (math.random() * 5 * FRAMES) or 0
    inst:DoTaskInTime(land_time, CLIENT_ForceFloaterUpdate)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.cherried = false 
    inst.angrychild = "killerbeebeetle"

    --
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "beebeetle"
    inst.components.childspawner.allowwater = true

    inst.components.childspawner:SetRegenPeriod(TUNING.BEEBEETLEDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.BEEBEETLEDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(TUNING.BEEBEETLEDEN_MAX_BEES)

    inst.components.childspawner.emergencychildname = "beebeetle"
    inst.components.childspawner.emergencychildrenperplayer = 1
    inst.components.childspawner:SetMaxEmergencyChildren(3)
    inst.components.childspawner:SetEmergencyRadius(TUNING.BEEHIVE_EMERGENCY_RADIUS)

    inst:DoTaskInTime(0, OnInit)

    --
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("beebeetleden")

    --
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.BEEBEETLEDEN_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)
    inst:ListenForEvent("on_collide", inst._OnCollide)

    --
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = function(inst) 
        inst.SoundEmitter:PlaySound("hookline_2/creatures/boss/crabking/gem_place")
        OnCherried(inst)
    end 
    inst.components.trader.deleteitemonaccept = false

    --
    inst:AddComponent("pickable")
    inst.components.pickable:SetUp("beebeetleboulder", TUNING.BEEBEETLEDEN_HARVEST_TIME)
    inst.components.pickable:SetOnPickedFn(OnPick)
    inst.components.pickable:SetOnRegenFn(UpdateAnim)

    --
    inst:AddComponent("inspectable")

    --
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    UpdateAnim(inst)

    return inst
end

return Prefab("beebeetleden", fn, assets, prefabs)