local shake_counter = 0

local function Reveal_Map(inst)
    if inst.last_attacker and inst.last_attacker.player_classified and inst.last_attacker.player_classified.MapExplorer then 
        local x, y, z = inst.Transform:GetWorldPosition()
        local angle_step = math.pi/30
        
        for radius = 0, TUNING.CLOCKWORK_TOWER_REVEAL_RANGE, 30 do 
            --decrease the angle only at the end of the circle for optimization
            if radius == TUNING.CLOCKWORK_TOWER_REVEAL_RANGE then
                angle_step = math.pi/160
            end

            for angle = 0, 2*math.pi, angle_step do             
                local revealx = radius * math.cos(angle) --parametric equation of a circle. thanks calc 3!
                local revealz = radius * math.sin(angle)

                inst.last_attacker.player_classified.MapExplorer:RevealArea(revealx + x, 0, revealz + z)
            end
        end
    
        --opens the map 
        inst.last_attacker.player_classified.revealmapspot_worldx:set(x)
        inst.last_attacker.player_classified.revealmapspot_worldz:set(z)
        inst.last_attacker.player_classified.revealmapspotevent:push()
    end
end

--make pawn slower, do less damage, and drop nothing for balance. similar changes to the um_modified_pawn scenario.
--these changes are saved by the um_pawn postinit 
local function NerfPawn(pawn) 
    if pawn.components.locomotor then 
        pawn.components.locomotor.runspeed = 4.8
        pawn.components.locomotor.walkspeed = 1
    end 
    if pawn.components.explosive then 
        pawn.components.explosive.explosivedamage = 50
    end 
    if pawn.components.lootdropper then 
        pawn.components.lootdropper:SetChanceLootTable(nil)
    end 
end 

local SetPawnTarget = function(pawn, player)
    if pawn.components.combat and player and not player.components.health:IsDead() and pawn.components.combat:CanTarget(player) then
        pawn.components.combat:SetTarget(player)
    end
end

local function MakePawn(inst, angle)
    local pawn = SpawnPrefab("um_pawn_nightmare")

    if inst.last_attacker then 
        local pt = inst.last_attacker:GetPosition()
        pawn.Transform:SetPosition(pt.x + (8 * math.cos(angle)), pt.y, pt.z + (8 * math.sin(angle)))
    else
        local pt = inst:GetPosition()
        pawn.Transform:SetPosition(pt.x + (8 * math.cos(angle)), pt.y, pt.z + (8 * math.sin(angle)))
    end

    NerfPawn(pawn)
    SetPawnTarget(pawn, inst.last_attacker)
end 

local function CanAttack(inst, target)
    target = target or inst.components.combat.target

    if target ~= nil and not target:IsValid() then
		target = nil
	end

	if target == nil then
		return false
	end

    if not inst.components.timer:TimerExists("GroundPound") then
		return true
    end
end

local states = { 
    State{
        name = "idle", 
        tags = { "idle", "canrotate" }, 
 
        onenter = function(inst) 
            inst.Physics:Stop() 
            inst.AnimState:PlayAnimation("idle_loop", true)
        end
    },
 
    State{
        name = "moving", 
        tags = { "moving", "canrotate" },
 
        onenter = function(inst)
            inst.components.locomotor:RunForward()
            inst.AnimState:PlayAnimation("walk_loop")
        end,
 
        timeline = {
            TimeEvent(0*FRAMES, function(inst) inst.Physics:Stop() end ),
            TimeEvent(7*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/bounce")
                inst.components.locomotor:RunForward()
            end ),
            TimeEvent(19*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/land")
                inst.Physics:Stop()
            end ),
        }, 
 
        events = { 
            EventHandler("animover", function(inst) inst.sg:GoToState("moving") end)
        }
    },
 
    State{
        name = "death",
        tags = {"busy"},
 
        onenter = function(inst)
            inst.AnimState:PlayAnimation("death")

            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
            
            inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop/death")
            inst.SoundEmitter:PlaySound("dontstarve/charlie/warn")

            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
            
            --this stuns the player learning the map
            if inst.last_attacker ~= nil and inst.last_attacker.AnimState ~= nil then  
                if inst.last_attacker.components.playercontroller ~= nil then
                    inst.last_attacker.components.playercontroller:Enable(false)
                end

                if inst.last_attacker.components.health and not inst.last_attacker.components.health:IsDead() then 
                    inst.last_attacker.AnimState:PlayAnimation("channel_pre")
                    inst.last_attacker.AnimState:PushAnimation("channel_loop", true)
                end 
            end
        end,

        timeline = {
            TimeEvent(5*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/death")
            end),
            TimeEvent(16*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
            end),
            TimeEvent(18*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/death") -- if you mix enough vanilla sounds together it almost sounds like you made your own B)
            end),
            TimeEvent(60*FRAMES, function(inst) 
                Reveal_Map(inst)
                --give the player control of their body again
                if inst.last_attacker ~= nil and inst.last_attacker.AnimState ~= nil and inst.last_attacker.components.playercontroller ~= nil then
                    inst.last_attacker.components.playercontroller:Enable(true)
                end
            end)
        }, 
    },

    State{
        name = "hit",
        tags = {"hit"},

        onenter = function(inst)
            inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/death")
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
        name = "pound",
        tags = {"attack", "busy"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("stomp")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/bounce")
        end,

        timeline =
		{
			FrameEvent(30, function(inst)
				inst.components.groundpounder:GroundPound()
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")

                inst.components.timer:StopTimer("GroundPound")
			    inst.components.timer:StartTimer("GroundPound", TUNING.CLOCKWORK_TOWER_POUND_COOLDOWN)
			end),
		},

        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "explode",
        tags = {"busy", "triplegroundpound"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("explode")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/bounce")

            inst.components.groundpounder.ringWidth = 8
        end,

        timeline =
		{
        FrameEvent(30, function(inst)
            inst.components.groundpounder:GroundPound()
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
        end),
        FrameEvent(40, function(inst)
            inst.components.groundpounder:GroundPound()
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
        end),
        FrameEvent(55, function(inst)
            inst.components.groundpounder:GroundPound()
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
        end),
        },

        events=
        {
            EventHandler("animover", function(inst)
                --spawn damaged pawns if uncompromising mode is installed and compatibility setting is enabled
                local taymid = KnownModIndex:GetModActualName("Taym's Flora and Fauna")
                if KnownModIndex:IsModEnabled("workshop-2039181790") and GetModConfigData("clockwork_tower_pawns", taymid) then 
                    MakePawn(inst, inst.pawn_angle)
                    MakePawn(inst, inst.pawn_angle - 2/3*math.pi) --spawn the other two pawns in a triangular formation. 
                    MakePawn(inst, inst.pawn_angle + 2/3*math.pi)
                end 

                inst.components.groundpounder.ringWidth = 4
                inst.sg:GoToState("idle")
            end),
        },
    },

    State{
        name = "startexplode",
        tags = {"busy", "triplegroundpound"},

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("startexplode")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/knight/hurt")
        end,

        events=
        {
            EventHandler("animover", function(inst)
                if shake_counter < 3 then 
                    shake_counter = shake_counter + 1
                    inst.sg:GoToState("startexplode")
                else
                    shake_counter = 0 
                    inst.sg:GoToState("explode")
                end

            end),
        },
    },
 
}

local events = {

    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    CommonHandlers.OnAttack(),
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

    EventHandler("doattack", function(inst, data)
		if not (inst.sg:HasStateTag("busy") or inst.components.health:IsDead()) then
			if CanAttack(inst, data ~= nil and data.target or nil) then
                inst.sg:GoToState("pound")
            end
		end
	end)
}

local actionhandlers = {}

return StateGraph("clockwork_tower", states, events, "idle", actionhandlers)