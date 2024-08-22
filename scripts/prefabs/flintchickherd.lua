local prefabs =
{
    "flintchick",
    "stonechick",
    "redgoldchick",
    "bluegoldchick",
}

local function CanSpawn(inst)
    return inst.components.herd ~= nil and not inst.components.herd:IsFull()
end

local function SetNextChick(inst)
    local randomchick = math.random()
    if inst.components.periodicspawner ~= nil then 
        if randomchick < 0.05 then 
            inst.components.periodicspawner:SetPrefab("redgoldchick")
        elseif randomchick < 0.1 then 
            inst.components.periodicspawner:SetPrefab("bluegoldchick")
        elseif randomchick < 0.5 then 
            inst.components.periodicspawner:SetPrefab("stonechick")
        else
            inst.components.periodicspawner:SetPrefab("flintchick")
        end
    end
end 

local function OnSpawned(inst, newent)
    if inst.components.herd ~= nil then
        inst.components.herd:AddMember(newent)
        SetNextChick(inst)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    --[[Non-networked entity]]

    inst:AddTag("herd")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst:AddComponent("herd")
    inst.components.herd:SetMemberTag("flintchick")
	inst.components.herd:SetMaxSize(TUNING.FLINTCHICKHERD_MAX_SIZE)
    inst.components.herd:SetGatherRange(40)
    inst.components.herd:SetUpdateRange(20)
    inst.components.herd.nomerging = true

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetRandomTimes(TUNING.FLINTCHICK_BABYDELAY, TUNING.FLINTCHICK_BABYDELAY_VARIANCE)
    SetNextChick(inst) -- to initially decide the next flintchick variant
    inst.components.periodicspawner:SetOnSpawnFn(OnSpawned)
    inst.components.periodicspawner:SetSpawnTestFn(CanSpawn)
    inst.components.periodicspawner:SetOnlySpawnOffscreen(true)
    inst.components.periodicspawner:SetIgnoreFlotsamGenerator(true)
    inst.components.periodicspawner:Start()

    return inst
end

return Prefab("flintchickherd", fn, nil, prefabs)