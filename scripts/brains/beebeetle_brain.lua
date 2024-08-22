require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/follow"

local MAX_CHASE_DIST = 7
local MAX_CHASE_TIME = 8
local MAX_WANDER_DIST = 15

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9

local SEE_DIST = 10
local SEE_FISH_DISTANCE = 10

local BrainCommon = require("brains/braincommon")

local BeebeetleBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    local homeseeker = inst.components.homeseeker
    if homeseeker
        and homeseeker.home
        and homeseeker.home:IsValid()
        and homeseeker.home.components.childspawner
        and not inst.components.follower.leader then 
            
        return BufferedAction(inst, homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetLeader(inst)
    return inst.components.follower ~= nil and inst.components.follower.leader or nil
end

local function fish_target_valid_on_action(ba)
    local target = ba.target
    return target ~= nil
        and not (target.components.inventoryitem and target.components.inventoryitem:IsHeld())
end

local function EatFoodAction(inst)
    local target = FindEntity(inst, SEE_DIST, function(item) return inst.components.eater:CanEat(item) and item:IsOnPassablePoint(true) end)
    return target ~= nil and BufferedAction(inst, target, ACTIONS.EAT) or nil
end

local OCEANFISH_TAGS = {"oceanfish"}
local function EatFishAction(inst)
    if inst.components.timer:TimerExists("eat_cooldown") then
        return nil
    end

    local target_fish = FindEntity(inst, SEE_FISH_DISTANCE,
        function(fish)
            return TheWorld.Map:IsOceanAtPoint(fish.Transform:GetWorldPosition())
        end,
        OCEANFISH_TAGS)
    if not target_fish then
        return nil
    end

    local eat_action = BufferedAction(inst, target_fish, ACTIONS.EAT)
    eat_action.validfn = fish_target_valid_on_action
    return eat_action
end

function BeebeetleBrain:OnStart()
    local root = PriorityNode(
    {
		BrainCommon.PanicTrigger(self.inst),

        ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME)),

        Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, false),

        IfNode(function() return (not TheWorld.state.iscaveday or not self.inst:IsInLight()) and not self.inst.honeycoma end, "IsNight",
            DoAction(self.inst, function() return GoHomeAction(self.inst) end, "go home", true )),
        
        IfNode(function() return not self.inst.honeycoma end, "Awake",
            DoAction(self.inst, EatFishAction, "Try Eating A Fish", nil, 15)),

        IfNode(function() return not self.inst.honeycoma end, "Awake",
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)), 

        --beebeetles in a honeycoma should stand still when awake
        StandStill(self.inst)
    }, 1)

    self.bt = BT(self.inst, root)
end

function BeebeetleBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", self.inst:GetPosition())
end

return BeebeetleBrain