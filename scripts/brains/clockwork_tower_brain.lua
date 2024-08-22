local GO_HOME_DIST = 1
local MAX_CHASE_TIME = 15
local MAX_CHASE_DIST = 20

local function GoHomeAction(inst)
    if inst.components.combat.target ~= nil then
        return
    end

    local homePos = inst.components.knownlocations:GetLocation("home")
    return homePos ~= nil
        and BufferedAction(inst, nil, ACTIONS.WALKTO, nil, homePos, nil, .2)
        or nil
end

local function ShouldGoHome(inst)
    local homePos = inst.components.knownlocations:GetLocation("home")

    if homePos == nil then 
    end

    return homePos ~= nil and inst:GetDistanceSqToPoint(homePos:Get()) > GO_HOME_DIST * GO_HOME_DIST

end

local Clockwork_Tower_Brain = Class(Brain, function(self, inst)
    Brain._ctor(self,inst)
end)


function Clockwork_Tower_Brain:OnStart()
    local root = PriorityNode(
        {
            ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
            WhileNode(function() return ShouldGoHome(self.inst) end, "ShouldGoHome",
                DoAction(self.inst, GoHomeAction, "Go Home", true)),

            StandStill(self.inst)
        }, 1)

    self.bt = BT(self.inst, root)
end

return Clockwork_Tower_Brain