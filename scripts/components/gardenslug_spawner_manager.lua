return Class(function(self, inst)

assert(TheWorld.ismastersim, "gardenslug_spawner_manager should not exist on client")

self.inst = inst 
local _spawners = {} 
local _slugbottles = {}

self.gardenslug_amount = 0

local function OnRemoveSpawner(spawner)
    for i, v in ipairs(_spawners) do
        if v == spawner then
            table.remove(_spawners, i)
            return
        end
    end
end

local function OnRegisterGardenslugSpawner(inst, spawner)
    for i, v in ipairs(_spawners) do
        if v == spawner then
            return
        end
    end

    table.insert(_spawners, spawner)
    inst:ListenForEvent("onremove", OnRemoveSpawner, spawner)
end

local function IncreaseGardenSlugs() 
    self.gardenslug_amount = self.gardenslug_amount + 1
    print("Number of Garden Slugs in the world: "..tostring(self.gardenslug_amount))
end 

local function ReduceGardenSlugs() 
    self.gardenslug_amount = self.gardenslug_amount - 1
    print("Number of Garden Slugs in the world: "..tostring(self.gardenslug_amount))
end 

function self:GetGardenSlugAmount()
    return self.gardenslug_amount 
end 

function self:SpawnGardenSlug() 
    if #_spawners == 0 then 
        print("GARDENSLUG HAS NO SPAWNERS!")
        return 
    end 

    _spawners = shuffleArray(_spawners)

    --pick a spawner that doesnt have any nearby players
    local x, y, z
    for i, v in ipairs(_spawners) do
        x, y, z = v.Transform:GetWorldPosition()
        if not IsAnyPlayerInRange(x, y, z, 35) then
            break
        end
        x = nil 
    end

    --if we couldn't find a spawner with no nearby players, just pick a random one 
    if x == nil and #_spawners > 0 then
        local spawner = _spawners[math.random(#_spawners)]
        x, y, z = spawner.Transform:GetWorldPosition()
    end

    if x ~= nil then 
        local spawned_gardenslug = SpawnPrefab("gardenslug")
        spawned_gardenslug.Transform:SetPosition(x, y, z)
        return spawned_gardenslug:GetPosition()--, reason=nil
    end 

    return nil, "NO_VALID_SPAWNPOINT"
end 


inst:ListenForEvent("taym_registergardenslug", OnRegisterGardenslugSpawner)
inst:ListenForEvent("taym_gardenslugcreated", IncreaseGardenSlugs)
inst:ListenForEvent("taym_gardenslugkilled", ReduceGardenSlugs)

end)