require("stategraphs/commonstates")

local events=
{
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnSink(),

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

    EventHandler("doattack", function(inst, data)
		if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("attack_pre")
		end
	end),

    EventHandler("attacked", function(inst)
        if not inst.components.health:IsDead() then
            inst.sg:GoToState("hit")
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
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/death")
            inst.AnimState:PlayAnimation("death")
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
            inst.AnimState:PlayAnimation("hit", false)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/hit")
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },


    State{
        name = "attack_pre",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop")
        end,

        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.sg:GoToState("attack") end),
        },
    },

    State{
        name = "attack",
        tags = {"attack", "busy"},

        onenter = function(inst, target)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("atk")
            inst.sg.statemem.target = target
        end,

        timeline=
        {
            TimeEvent(15*FRAMES, function(inst) inst.components.combat:DoAttack(inst.sg.statemem.target) end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "moving", 
        tags = { "moving", "canrotate" },
 
        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk_loop")
        end,

        timeline = {
		    TimeEvent(0*FRAMES, function(inst)
		    inst.Physics:Stop()
            if math.random() <= 0.33 then inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/idle") end
            inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/slide_out")
            end ),

            TimeEvent(13*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/slurtle/slide_in")
                inst.components.locomotor:WalkForward()
            end ),
            TimeEvent(21*FRAMES, function(inst)
                inst.Physics:Stop()
            end ),
        },
 
        events = { 
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end)
        }
    },

    State{
        name = "hatch_pre", 
        tags = {"busy"},
 
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hatch_pre")
        end,

        timeline = {
		    TimeEvent(12*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/land")
            end ),

            TimeEvent(25*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/hutch/land")
            end ),

        },
 
        events = { 
            EventHandler("animover", function(inst) inst.sg:GoToState("hatch") end)
        }
    },

    State{
        name = "hatch", 
        tags = {"busy"},
 
        onenter = function(inst)
            inst.AnimState:PlayAnimation("hatch")
        end,
 
        timeline = {
		    TimeEvent(10*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_down")
            end ),
        },

        events = { 
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end)
        }
    },
}

CommonStates.AddFrozenStates(states)
CommonStates.AddSleepStates(states)
CommonStates.AddSinkAndWashAshoreStates(states)

return StateGraph("slugling", states, events, "idle")
