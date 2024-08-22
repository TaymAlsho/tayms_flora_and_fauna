require("stategraphs/commonstates")

local on_ground = function(inst)
    local position = Vector3(inst.Transform:GetWorldPosition())
    local x = position.x
    local z = position.z
    return TheWorld.Map:IsVisualGroundAtPoint(x,0,z)
end 

local pickanim = function(inst, name) -- decides if flintchick should play ground or water animations
    if on_ground(inst) then 
        return name 
    else 
        return name.."_water"
    end
end

local events=
{
    CommonHandlers.OnStep(),
    CommonHandlers.OnSleep(),

    EventHandler("locomote", function(inst)
        if not inst.sg:HasStateTag("busy") then
            local is_moving = inst.sg:HasStateTag("moving")
            local wants_to_move = inst.components.locomotor:WantsToMoveForward()
 
            if is_moving ~= wants_to_move then
                if wants_to_move then
                    inst.sg:GoToState("moving")
                else
                    inst.sg:GoToState("idle")
                end
            end
        end
    end),
}

local states=
{
    State{
        name = "idle",
        tags = {"idle", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation(pickanim(inst, "idle_loop"), true)
        end,
    },

    State{
        name = "alert",
        tags = {"alert", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PlayAnimation(pickanim(inst, "alert_pre"))
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("alert_loop") end ),
        },
    },

    State{
        name = "alert_loop",
        tags = {"alert", "canrotate"},

        onenter = function(inst)
            inst.components.locomotor:StopMoving()
            inst.AnimState:PushAnimation(pickanim(inst, "alert"), true)
            inst.SoundEmitter:PlaySound("dontstarve/ghost/bloodpump")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("alert_loop") end ),
        },
    },

    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/hurt")
            inst.AnimState:PlayAnimation(pickanim(inst, "death"))
            inst.components.locomotor:StopMoving()
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
        end,

    },

    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
			CommonHandlers.UpdateHitRecoveryDelay(inst)
            inst.AnimState:PlayAnimation(pickanim(inst, "hit"), false)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bunnyman/hurt")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

    State{
        name = "moving", 
        tags = { "moving", "canrotate" },
 
        onenter = function(inst)
            inst.AnimState:PlayAnimation(pickanim(inst, "walk_loop"), true)
            inst.components.locomotor:WalkForward()
        end,

        timeline = {
            TimeEvent(0*FRAMES, function(inst) 
                if on_ground(inst) then 
                    inst.Physics:Stop() 
                else 
                    inst.components.locomotor:WalkForward()
                end 
            end ),
            TimeEvent(5*FRAMES, function(inst)
                inst.components.locomotor:WalkForward()
            end ),
            TimeEvent(15*FRAMES, function(inst)
                if on_ground(inst) then 
                    inst.Physics:Stop() 
                else 
                    inst.components.locomotor:WalkForward()
                end 
            end ),
        },
 
        events = { 
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end)
        }
    },

}

return StateGraph("flintchick", states, events, "idle")