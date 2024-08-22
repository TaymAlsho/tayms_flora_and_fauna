local assets =
{
    Asset("ANIM", "anim/beebeetle.zip"),
    Asset("ANIM", "anim/killerbeebeetle.zip"),
    Asset("ANIM", "anim/hibeebeetle.zip"),
}

local prefabs =
{
    "honey",
    "insect_meat_raw"
}

SetSharedLootTable("beebeetle", 
{
    {"honey",            0.75},
    {"honey",            0.75},
    {"insect_meat_raw",  0.75},
})

local SHARE_TARGET_DIST = 30
local MAX_TARGET_SHARES = 10

local DIET = { FOODTYPE.MEAT }

local function bonus_damage_via_allergy(inst, target, damage, weapon)
    return (target:HasTag("allergictobees") and TUNING.BEE_ALLERGY_EXTRADAMAGE) or 0
end

local RETARGET_MUST_TAGS = { "_combat", "_health" }
local RETARGET_CANT_TAGS = { "insect", "INLIMBO", }
local RETARGET_ONEOF_TAGS = { "character", "animal", "monster" }
local function KillerRetarget(inst)
    return FindEntity(inst, SpringCombatMod(8),
        function(guy)
            return inst.components.combat:CanTarget(guy) and
                not (guy.components.skilltreeupdater and guy.components.skilltreeupdater:IsActivated("wormwood_bugs"))
        end,
        RETARGET_MUST_TAGS,
        RETARGET_CANT_TAGS,
        RETARGET_ONEOF_TAGS)
end

local function SpringRetarget(inst)
    if TheWorld.state.isspring and not inst.honeycoma then 
        return KillerRetarget(inst)
    end 
end 

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    inst.components.combat:SetTarget(attacker)
    local targetshares = MAX_TARGET_SHARES

    if inst.components.combat:HasTarget() then
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            if home and home.components.childspawner then
                targetshares = targetshares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker, home.angrychild) --uses home.angrychild rather than 'killerbeebeetle' so that the den releases hibeetles when cherrified
            end
        end
    end

    local iscompanion = inst:HasTag("companion")
    inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude)
        if inst.components.homeseeker and dude.components.homeseeker then  --don't bring beebeetles from other hives
            if dude.components.homeseeker.home and dude.components.homeseeker.home ~= inst.components.homeseeker.home then
                return false
            end
        end
        return dude:HasTag("beebeetle") and (iscompanion == dude:HasTag("companion")) and not (dude:IsInLimbo() or dude.components.health:IsDead() or dude:HasTag("epic"))
    end, targetshares)
end

local function OnEnterWater(inst)
    for i = 1, 3 do 
        inst.AnimState:Show(tostring(i).."water") --shows the water reflection on the beebeetles legs
    end
end 

local function OnExitWater(inst)
    for i = 1, 3 do 
        inst.AnimState:Hide(tostring(i).."water") --hides the water reflection on the beebeetles legs
    end
end 

--hides water reflection if beebeetle is initially loaded on land 
local function CheckOnGround(inst)
    local position = Vector3(inst.Transform:GetWorldPosition())
    local x = position.x
    local z = position.z

    if TheWorld.Map:IsVisualGroundAtPoint(x,0,z) then 
        OnExitWater(inst)
    end 
end 

local function HoneyComaWakeCheck(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local playerents = TheSim:FindEntities(x, y, z, 4, {"player"})

    --wakeup if there is a nearby player so that the beebeetle can be fed honey
    if inst.sg and #playerents ~= 0 and inst.components.sleeper:IsHibernating() then 
        inst.components.sleeper:WakeUp()
        inst.sg:GoToState("honeycoma_wake")
    
    --go back to sleep if no one is nearby and the beebeetle isnt in combat
    elseif inst.sg and #playerents == 0 and inst.components.combat.target == nil and not inst.components.sleeper:IsHibernating() then 
        inst.sg:GoToState("sleep")
        inst.components.sleeper.hibernate = true
    end 
end 
    
local function OnHoneyComa(inst) 
    inst.honeycoma = true 
    inst.components.follower:SetLeader(nil)
	inst.sleeptask = inst:DoPeriodicTask(3, HoneyComaWakeCheck)
end 

local function ShouldAcceptItem(inst, item)
    --accept a heavy enough oceanfish to become a follower if the beebeetle is not in a honeycoma
    return (item:HasTag("oceanfish") and item.components.weighable and not inst.honeycoma
           and item.components.weighable:GetWeightPercent() >= TUNING.WEIGHABLE_HEAVY_WEIGHT_PERCENT)
    --or, accept honey if the beebeetle is following someone in order to go into a honeycoma, or is already in a honeycoma in order to go back to being a follower
           or (item:HasTag("honeyed") and (inst.components.follower.leader or inst.honeycoma))
end 

local function OnGetItemFromPlayer(inst, giver, item)
    if item:HasTag("oceanfish") and giver.components.leader ~= nil then 
        giver:PushEvent("makefriend")
        giver.components.leader:AddFollower(inst)

        inst:PushEvent("detachchild")
        inst.sg:GoToState("eat")

    --put beebeetle into coma if fed honey as a follower
    elseif item:HasTag("honeyed") and inst.components.follower.leader then 
        OnHoneyComa(inst)

    --take beebeetle out of coma and redo follower state if fed honey while in a coma 
    elseif item:HasTag("honeyed") and giver.components.leader ~= nil then 
        inst.honeycoma = false 
        if inst.sleeptask then 
            inst.sleeptask:Cancel()
        end 

        giver.components.leader:AddFollower(inst)
        inst.sg:GoToState("eat")
    end 
end 

local function OnRefuseItem(inst, giver, item)
    inst.sg:GoToState("taunt")
end 

local function worker_OnIsSpring(inst, isspring)
    if isspring then
        inst.AnimState:SetBuild("killerbeebeetle")
    else 
        inst.AnimState:SetBuild("beebeetle")
    end 
end

--only for hibeebeetles
local function OnShaved(inst, shaver, shave_item)
    local newbeetle = SpawnPrefab("beebeetle")
    newbeetle.Transform:SetPosition(inst:GetPosition():Get())
    newbeetle.components.combat:SetTarget(shaver)

    inst:Remove()
end 

local function OnSave(inst, data)
    data.honeycoma = inst.honeycoma 
end 

local function OnLoad(inst, data)
    if data and data.honeycoma == true then 
        OnHoneyComa(inst)
    end 
end 

-- gives hibeetles the same poison damage as a hibeescus 
-- taken with permission from cherry_bees with some adjustments! {
local function CherryAttackOther(inst, data)
    if not KnownModIndex:IsModEnabled("workshop-1289779251") then --double check that cherry forest is enabled
        return 
    end 

    if data.target ~= nil and not (data.target.components.health ~= nil and data.target.components.health:IsDead()) and
		not data.target:HasTag("playerghost") then
		if data.target.components.inventory ~= nil then
			for k, eslot in pairs(EQUIPSLOTS) do
				local equip = data.target.components.inventory:GetEquippedItem(eslot)
				if equip ~= nil and (equip.components.armor ~= nil and (equip.components.armor.tags ~= nil and equip.components.armor:CanResist(inst)
					or (equip.components.armor:GetAbsorption(inst) or 0) >= 1)
					or equip.components.resistance ~= nil and equip.components.resistance:HasResistance(inst) and equip.components.resistance:ShouldResistDamage()) then
					return
				end
			end
		end
		
		if data.target.components.debuffable == nil then
			data.target:AddComponent("debuffable")
		end
		if not data.target.components.health:IsInvincible() and data.target.components.debuffable ~= nil and data.target.components.debuffable:IsEnabled() ~= nil then
			local poison = data.target.components.debuffable:AddDebuff("cherry_beepoisonbuff", "cherry_beepoisonbuff")
			if poison ~= nil and poison.stacks then
				poison.stacks = poison.stacks == 0 and TUNING.CHERRY_BEEPOISON_TICK_VALUE or poison.stacks + (TUNING.CHERRY_BEEPOISON_TICK_VALUE * 0.5)
			end
		end
	end
end 
-- }

local function commonfn(build)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 30, .5)

    inst.DynamicShadow:SetSize(3, 1)
    inst.Transform:SetTwoFaced()

    inst:AddTag("scarytooceanprey")
    inst:AddTag("bee")
    inst:AddTag("insect")
    inst:AddTag("beebeetle")

    inst.AnimState:SetBank("beebeetle")
    inst.AnimState:SetBuild(build)
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst.honeycoma = false 

    --
    inst:AddComponent("amphibiouscreature")
    inst.components.amphibiouscreature:SetEnterWaterFn(OnEnterWater)
    inst.components.amphibiouscreature:SetExitWaterFn(OnExitWater)
    inst:DoTaskInTime(0, CheckOnGround)

    --
    inst:AddComponent("timer")

    --
    inst:AddComponent("follower")

    --
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst:SetStateGraph("SGbeebeetle")
    inst.components.locomotor:SetAllowPlatformHopping(true)
    inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED_FAST
    inst.components.locomotor.runspeed = TUNING.BEEBEETLE_SPEED_FAST
    inst.components.locomotor.hop_distance = 4

    --
    inst:AddComponent("embarker")
    inst.components.embarker.embark_speed = inst.components.locomotor.runspeed

    --
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("beebeetle")

    -- eater doesn't actually do much outside of trading since beebeetles dont look for food on the ground
    inst:AddComponent("eater")
    inst.components.eater:SetDiet(DIET, DIET)
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetStrongStomach(true)
    inst.components.eater:SetCanEatRawMeat(true)

    --
    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")

    --
    inst:AddComponent("health")
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat.bonusdamagefn = bonus_damage_via_allergy
    inst.components.combat:SetAttackPeriod(TUNING.BEEBEETLE_ATTACK_PERIOD)
    inst.components.combat:SetRange(TUNING.BEEBEETLE_ATTACK_RANGE)

    --
    inst:AddComponent("sleeper")

    --
    inst:AddComponent("knownlocations")

    --
    inst:AddComponent("inspectable")

    --
    inst:ListenForEvent("attacked", OnAttacked)

    --
    MakeHauntablePanic(inst)

    --
    inst.OnSave = OnSave 
    inst.OnLoad = OnLoad 

    return inst
end

local workerbrain = require("brains/beebeetle_brain")
local killerbrain = require("brains/killerbeebeetle_brain")

local function workerbeebeetle()
    local inst = commonfn("beebeetle")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:WatchWorldState("isspring", worker_OnIsSpring)
    if TheWorld.state.isspring then
        worker_OnIsSpring(inst, true)
    end

    --
    inst.components.combat:SetRetargetFunction(2, SpringRetarget)
    inst.components.health:SetMaxHealth(TUNING.BEEBEETLE_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.BEEBEETLE_DAMAGE)

    --
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    --
    inst:SetBrain(workerbrain)

    return inst
end

local function killerbeebeetle()
    local inst = commonfn("killerbeebeetle")

    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst.components.combat:SetRetargetFunction(2, KillerRetarget)
    inst.components.health:SetMaxHealth(TUNING.KILLERBEEBEETLE_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.KILLERBEEBEETLE_DAMAGE)

    --
    inst:SetBrain(killerbrain)

    return inst
end

local function hibeebeetle()
    local inst = commonfn("hibeebeetle")
    inst:AddTag("cherrybee")

    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst.components.combat:SetRetargetFunction(2, SpringRetarget)
    inst.components.health:SetMaxHealth(TUNING.KILLERBEEBEETLE_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.BEEBEETLE_DAMAGE)

    --
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem
    inst.components.trader.deleteitemonaccept = false

    --
    inst:AddComponent("shaveable")
	inst.components.shaveable:SetPrize("petals", 3)
	inst.components.shaveable.on_shaved = OnShaved

    if KnownModIndex:IsModEnabled("workshop-1289779251") then 
        inst:ListenForEvent("onattackother", CherryAttackOther)
    end 

    --
    inst:SetBrain(workerbrain)

    return inst
end 

return Prefab("beebeetle", workerbeebeetle, assets, prefabs),
       Prefab("killerbeebeetle", killerbeebeetle, assets, prefabs),
       Prefab("hibeebeetle", hibeebeetle, assets, prefabs)
