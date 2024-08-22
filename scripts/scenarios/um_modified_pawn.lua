--[[ this slightly modifies the damaged pawns spawned by the "clockwork_tower_spawner" static layout
to be more on par with what you'd expect to see on the early game surface.
changes include a much slower speed, half the damage, and no loot drops 
when these pawns die, it also makes the clockwork tower do the triple pound attack]]

local function WakeCheck(inst) 
    local x, y, z = inst.Transform:GetWorldPosition()
    local playerents = TheSim:FindEntities(x, y, z, 10, {"player"})

    if #playerents ~= 0 and inst.sg then 
        inst.sg:GoToState("idle")

        if inst.components.combat then
            for _, player in ipairs(playerents) do 
                if player.components.health and not player.components.health:IsDead() 
                   and inst.components.combat:CanTarget(player) then

                    inst.components.combat:SetTarget(player)
                    inst.sleeptask:Cancel()
                    break
                end 
            end 
        end
    end 
end 

local function NewOnExplode(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local clockworktowerents = TheSim:FindEntities(x, y, z, 30, {"clockworktower"})
    local playerents = TheSim:FindEntities(x, y, z, 20, {"player"})
    
    for _, clockworktower in ipairs(clockworktowerents) do 
        if clockworktower.components.health and not clockworktower.components.health:IsDead() and clockworktower.sg then

            for _, player in ipairs(playerents) do 
                if player.components.health and not player.components.health:IsDead() then 
                    clockworktower.last_attacker = player 
                    break 
                end 
            end 

            if not clockworktower.sg:HasStateTag("triplegroundpound") then
                clockworktower.switch_counter = 0 
                clockworktower.explosionswitches(clockworktower)
                clockworktower.sg:GoToState("startexplode")
            end 
            
            break
        end 
    end 
end 

local function OnCreate(inst, scenariorunner)
end 

local function OnLoad(inst, scenariorunner)
    if inst.components.locomotor then 
        inst.components.locomotor.runspeed = 5
        inst.components.locomotor.walkspeed = 1
    end 

    if inst.components.explosive then 
        inst.components.explosive.explosivedamage = 100

        local OldOnExplode = inst.components.explosive.onexplodefn
        inst.components.explosive:SetOnExplodeFn(function(inst)
            OldOnExplode(inst)
            NewOnExplode(inst)
        end)
    end 

    if inst.components.lootdropper then 
        inst.components.lootdropper:SetChanceLootTable(nil)
    end 

    if inst.sg then 
        inst.sg:GoToState("sleep")
        inst.sleeptask = inst:DoPeriodicTask(1, WakeCheck)
    end 
end 

local function OnDestroy(inst)
end 

return {
    OnCreate = OnCreate,
    OnLoad = OnLoad, 
    OnDestroy = OnDestroy
}