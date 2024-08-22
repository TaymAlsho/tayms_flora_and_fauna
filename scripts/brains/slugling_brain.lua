require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/follow"
local BrainCommon = require("brains/braincommon")

local MIN_FOLLOW_DIST = 1
local MAX_FOLLOW_DIST = 1.5
local TARGET_FOLLOW_DIST = (MIN_FOLLOW_DIST+MAX_FOLLOW_DIST)/2
local MAX_CHASE_TIME = 2

local function GetLeader(inst)
    return inst.components.follower ~= nil and inst.components.follower.leader or nil
end

local SluglingBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function SluglingBrain:OnStart()

    local root =
        PriorityNode(
        {
            BrainCommon.PanicTrigger(self.inst),
			ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME)),
            Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, false),
            StandStill(self.inst),
      },1)

    self.bt = BT(self.inst, root)
end

return SluglingBrain