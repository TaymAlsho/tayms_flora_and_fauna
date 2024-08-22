require "behaviours/wander"
require "behaviours/faceentity"

local START_FACE_DIST = 5
local KEEP_FACE_DIST = 6
local WANDER_DIST_DAY = 20
local WANDER_DIST_NIGHT = 5

local function GetFaceTargetFn(inst)
    local target = FindClosestPlayerToInst(inst, START_FACE_DIST, true)
    return target ~= nil and not target:HasTag("notarget") and target or nil
end

local function KeepFaceTargetFn(inst, target)
    return not target:HasTag("notarget") and inst:IsNear(target, KEEP_FACE_DIST)
end

local function GetWanderDistFn(inst)
    return TheWorld.state.isday and WANDER_DIST_DAY or WANDER_DIST_NIGHT
end

local FlintchickBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function FlintchickBrain:OnStart()
    local root = PriorityNode(
    {
        FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("herd") end, GetWanderDistFn),
    }, .25)

    self.bt = BT(self.inst, root)
end

return FlintchickBrain
