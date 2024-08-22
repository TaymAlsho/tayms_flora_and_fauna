require "behaviours/wander"
require "behaviours/runaway"
local BrainCommon = require("brains/braincommon")

local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 10

local function ShouldRunAway(guy)
    return guy:HasTag("character") and not guy:HasTag("notarget")
end

local GardenslugBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function GardenslugBrain:OnStart()
    local root = PriorityNode(
    {
        BrainCommon.PanicTrigger(self.inst),
        RunAway(self.inst, ShouldRunAway, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),
        Wander(self.inst),
    }, .25)

    self.bt = BT(self.inst, root)
end

return GardenslugBrain
