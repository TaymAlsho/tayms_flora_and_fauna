require("stategraphs/commonstates")

local events=
{
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnDeath(),

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
            inst.AnimState:PlayAnimation("idle_loop", true)
        end,
    },

    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")
            inst.components.locomotor:StopMoving()
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
        end,

    },

    State{
        name = "hit",
        tags = {"hit", "busy"},

        onenter = function(inst)
            inst.Physics:Stop()
			CommonHandlers.UpdateHitRecoveryDelay(inst)
            inst.AnimState:PlayAnimation("hit", false)
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
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("walk_loop")
        end,
        
        timeline = {
		    TimeEvent(0*FRAMES, function(inst)
		    inst.Physics:Stop()
            if math.random() <= 0.33 then inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/idle") end
            inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/slide_out")
            end ),

            TimeEvent(17*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/slide_in")
                inst.components.locomotor:WalkForward()
            end ),
            TimeEvent(30*FRAMES, function(inst)
                inst.Physics:Stop()
            end ),
	    },

        events = { 
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end)
        }
    },
}

CommonStates.AddFrozenStates(states)

return StateGraph("gardenslug", states, events, "idle")