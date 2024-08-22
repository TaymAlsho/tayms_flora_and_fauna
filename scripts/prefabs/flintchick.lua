local brain = require "brains/flintchick_brain"

local prefabs =
{
    "floaty_flint",
    "smallmeat",
    "nightmarefuel",

    "floaty_rocks",
    "floaty_nitre",

    "floaty_goldnugget",
    "redgem",
    "bluegem",

    "flintchickherd",
}

SetSharedLootTable( 'flintchick',
{
    {'floaty_flint',  1},
    {'floaty_flint',  1},
    {'floaty_flint',  0.5},

    {'smallmeat',  0.1},
    {'nightmarefuel',  0.01},
})

SetSharedLootTable( 'stonechick',
{
    {'floaty_nitre',  1},
    {'floaty_rocks',  1},
    {'floaty_rocks',  1},
    {'floaty_rocks',  1},
    {'floaty_rocks',  0.5},

    {'smallmeat',  0.1},
    {'nightmarefuel',  0.01},
})

SetSharedLootTable( 'redgoldchick',
{
    {'floaty_goldnugget',  1},
    {'floaty_goldnugget',  1},
    {'floaty_goldnugget',  0.5},
    {'redgem',  1},

    {'smallmeat',  0.1},
    {'nightmarefuel',  0.1},
})

SetSharedLootTable( 'bluegoldchick',
{
    {'floaty_goldnugget',  1},
    {'floaty_goldnugget',  1},
    {'floaty_goldnugget',  0.5},
    {'bluegem',  1},

    {'smallmeat',  0.1},
    {'nightmarefuel',  0.1},
})

local mineamounts = {
    ["flint"] = 3,
    ["stone"] = 5,
    ["redgold"] = 7,
    ["bluegold"] = 7,
}

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        SpawnPrefab("rock_break_fx").Transform:SetPosition(inst:GetPosition():Get())
        inst.sg:GoToState("death")
        --inst:PushEvent("death", {afflicter = worker})
        inst:DoTaskInTime(2, ErodeAway)
    else
        inst.sg:GoToState("hit")
    end
end

local function makechick(type)
    local assets =
    {
    Asset("ANIM", "anim/flintchick.zip"),
    Asset("ANIM", "anim/"..type.."chick.zip"),
    }

    local function fn()

        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddDynamicShadow()
        inst.entity:AddNetwork()

        MakeCharacterPhysics(inst, 50, .5)

        inst.DynamicShadow:SetSize(1.5, .75)
        inst.Transform:SetTwoFaced()

        inst.AnimState:SetBank("flintchick")
        inst.AnimState:SetBuild(type.."chick")

        MakeInventoryFloatable(inst)
        local land_time = (POPULATING and math.random()*5*FRAMES) or 0
        inst:DoTaskInTime(land_time, function(inst)
            inst.components.floater:OnLandedServer()
        end)

        inst:AddTag("flintchick")
        inst:AddTag("herdmember")

        --
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        --
        inst:AddComponent("locomotor")
        inst.components.locomotor.walkspeed = 1

        --
        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetChanceLootTable(type.."chick")

        --
        local workable = inst:AddComponent("workable")
        workable:SetWorkAction(ACTIONS.MINE)
        workable:SetWorkLeft(mineamounts[type])
        workable:SetOnWorkCallback(OnWork)
        workable.savestate = true

        --
        inst:AddComponent("knownlocations")
        inst:AddComponent("herdmember")
        inst.components.herdmember:SetHerdPrefab("flintchickherd")

        --
        inst:AddComponent("inspectable")

        -- 
        inst:AddComponent("sleeper")

        --
        inst:SetStateGraph("SGflintchick")
        inst:SetBrain(brain)
        
        return inst
    end 

    return Prefab(type.."chick", fn, assets, prefabs)
end

return makechick("flint"),
    makechick("stone"),
    makechick("redgold"),
    makechick("bluegold")
