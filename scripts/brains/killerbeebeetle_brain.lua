require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
local BrainCommon = require("brains/braincommon")

local RUN_AWAY_DIST = 10
local SEE_TARGET_DIST = 6
local MAX_CHASE_DIST = 7
local MAX_CHASE_TIME = 8
local MAX_WANDER_DIST = 32

local function GoHomeAction(inst)
    local homeseeker = inst.components.homeseeker
    if homeseeker
        and homeseeker.home
        and homeseeker.home:IsValid()
        and homeseeker.home.components.childspawner
        and inst.components.combat.target == nil then
        return BufferedAction(inst, homeseeker.home, ACTIONS.GOHOME)
    end
end

local KillerBeebeetleBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function KillerBeebeetleBrain:OnStart()
    local root =
        PriorityNode(
        {
			BrainCommon.PanicTrigger(self.inst),
            ChaseAndAttack(self.inst, SpringCombatMod(MAX_CHASE_TIME)),
            DoAction(self.inst, function() return GoHomeAction(self.inst) end, "go home", true ),
            Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
        },1)


    self.bt = BT(self.inst, root)
end

function KillerBeebeetleBrain:OnInitializationComplete()
    self.inst.components.knownlocations:RememberLocation("home", Point(self.inst.Transform:GetWorldPosition()))
end

return KillerBeebeetleBrain
