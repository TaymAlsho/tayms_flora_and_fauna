require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.GOHOME, "eat"),
    ActionHandler(ACTIONS.EAT, "eat"),
}

local events =
{
    CommonHandlers.OnHop(),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnDeath(),
    CommonHandlers.OnAttacked(),
    CommonHandlers.OnFreeze(),
    
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

    EventHandler("doattack", function(inst)
        if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
            inst.sg:GoToState("attack")
        end
    end),
}

local states =
{
    State{
        name = "death",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/die")
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            if inst.components.lootdropper ~= nil then
                inst.components.lootdropper:DropLoot(inst:GetPosition())
            end
        end,
    },

    State{
        name = "moving",
        tags = { "moving", "canrotate" },

        onenter = function(inst)
            inst.AnimState:PlayAnimation("walk_loop", true)

            if not inst.components.amphibiouscreature.in_water then 
                inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED
            else 
                inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED_WATER
            end 

            inst.components.locomotor:WalkForward()
        end,

        timeline=
        {
            TimeEvent(3*FRAMES, function(inst) 
                if not inst.components.amphibiouscreature.in_water then 
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/walk_spider") 
                    inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED_FAST
                else 
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/walk_water") 
                    inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED_WATER_FAST
                end 

                --locomotor must be called again after speed is changed
                inst.components.locomotor:WalkForward()
            end),

            TimeEvent(9*FRAMES, function(inst) 
                if not inst.components.amphibiouscreature.in_water then 
                    inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED
                else 
                    inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED_WATER
                end 

                inst.components.locomotor:WalkForward()
            end),

            TimeEvent(12*FRAMES, function(inst) 
                if not inst.components.amphibiouscreature.in_water then 
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/walk_spider")
                    inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED_FAST 
                else 
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/walk_water") 
                    inst.components.locomotor.walkspeed = TUNING.BEEBEETLE_SPEED_WATER_FAST
                end 

                inst.components.locomotor:WalkForward()
            end),

            TimeEvent(14*FRAMES, function(inst) 
                if not inst.components.amphibiouscreature.in_water then 
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/walk_spider") 
                else 
                    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/walk_water") 
                end  
            end),
        },

        events = { 
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end)
        }
    },

    State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop")
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "attack",
        tags = { "attack", "busy" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("attack")
        end,

        timeline =
        {
            TimeEvent(15 * FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/attack")
                inst.components.combat:DoAttack()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "hit",
        tags = { "busy" },

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hit")
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
        end,

        timeline=
        {
            TimeEvent(5*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/taunt") end),
        },

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },

    State{
        name = "eat",
        tags = { "busy" },

        onenter = function(inst, forced)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat")
            inst.sg.statemem.forced = forced
        end,

        timeline =
        {
            TimeEvent(6*FRAMES, function(inst)
                if inst.components.amphibiouscreature.in_water then
                    local breach_fx = SpawnPrefab("ocean_splash_small1")
                    breach_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
                end

                inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/eat", "eating")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                inst.sg.statemem._eating = false

                local action = inst:GetBufferedAction()
                if action and action.target and action.target:IsValid() then
                    if action.target.components.oceanfishable then
                        local rod = action.target.components.oceanfishable:GetRod()
                        if rod then
                            inst:PushEvent("attacked", {attacker = rod.components.oceanfishingrod.fisher})
                        end

                        action.target:Remove()

                        inst.sg.statemem._eating = true
                        inst:ClearBufferedAction()
                    else
                        inst.sg.statemem._eating = inst:PerformBufferedAction()
                    end
                end

                if inst.sg.statemem._eating then
                    inst.components.timer:StartTimer("eat_cooldown", TUNING.SPIDER_WATER_EATCD)
                    inst.sg:GoToState("eat_loop")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    },

    State{
        name = "eat_loop",
        tags = {"busy"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("eat_loop", true)
            inst.sg:SetTimeout(1+math.random()*1)
        end,

        ontimeout = function(inst)
            inst.sg:GoToState("idle", "eat_pst")
        end,

        onexit = function(inst)
            inst.SoundEmitter:KillSound("eating")
        end,
    },

    State{
        name = "honeycoma_wake",
        tags = {"busy"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("sleep_pst", true)
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    },
}

CommonStates.AddSleepStates(states,
{
    --dont make noises during a honeycoma, only because it gets annoying
    starttimeline = {
        TimeEvent(0*FRAMES, function(inst) if not inst.honeycoma then inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/fallAsleep") end end ),
    },
    sleeptimeline =
    {
        TimeEvent(10*FRAMES, function(inst) if not inst.honeycoma then inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/sleeping") end end ),
    },
    waketimeline = {
        TimeEvent(0*FRAMES, function(inst) if not inst.honeycoma then inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/wakeUp") end end ),
    },
})

CommonStates.AddFrozenStates(states)
CommonStates.AddSinkAndWashAshoreStates(states)

CommonStates.AddAmphibiousCreatureHopStates(states,
{ -- config
    swimming_clear_collision_frame = 5*FRAMES,
},
nil,
{ -- timelines
    hop_pre =
    {
        TimeEvent(0, function(inst)
            if inst:HasTag("swimming") then
                SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end),
    },
    hop_pst = {
        TimeEvent(4 * FRAMES, function(inst)
            if inst:HasTag("swimming") then
                inst.components.locomotor:Stop()
                SpawnPrefab("splash_green").Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end),
        TimeEvent(6 * FRAMES, function(inst)
            if not inst:HasTag("swimming") then
                inst.components.locomotor:StopMoving()
            end
        end),
    }
})

return StateGraph("beebeetle", states, events, "idle", actionhandlers)