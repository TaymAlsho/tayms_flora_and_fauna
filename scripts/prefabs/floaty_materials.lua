--[[ the purpose of this file is to make "fake" rock materials that will float rather than sink in the ocean
this works by simply giving the "real" prefab when the floating "fake" is picked up 
these are dropped by flintchicks so that their resources are possible to get on the ocean 
]]

local prefabs = 
{
    "flint", 
    "rocks",
    "goldnugget",
    "nitre"
}

local rocknames = { "f1", "f2", "f3" } -- for different rock animations
local assets

local function makefloaty(name)

    if name == "goldnugget" then -- need to do this because goldnugget's prefab name and anim file name are different
        assets = {Asset("ANIM", "anim/gold_nugget.zip"),}
    else 
        assets = {Asset("ANIM", "anim/"..name..".zip"),}
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        if name == "goldnugget" then 
            inst.AnimState:SetBank(name)
            inst.AnimState:SetBuild("gold_nugget") -- bank name is goldnugget and build name is gold_nugget... no idea why it's inconsistent 
            inst.pickupsound = "dontstarve/common/metal"
        else
            inst.AnimState:SetBank(name)
            inst.AnimState:SetBuild(name)
            inst.pickupsound = "dontstarve/common/rock"
        end 

        if name == "rocks" then 
            inst.AnimState:PlayAnimation(rocknames[math.random(#rocknames)])
        else 
            inst.AnimState:PlayAnimation("idle")
        end

        MakeInventoryFloatable(inst, "small", 0.10, 0.80)
        inst:DoTaskInTime(0, function(inst)
            inst.components.floater:OnLandedServer()
        end)

        --
        inst.entity:SetPristine()
        if not TheWorld.ismastersim then
            return inst
        end

        --
        inst:AddComponent("inspectable")

        --
        inst:AddComponent("pickable")
        inst.components.pickable.picksound = inst.pickupsound
        inst.components.pickable:SetUp(name, 10)
        inst.components.pickable.remove_when_picked = true
        inst.components.pickable.quickpick = true

        return inst
    end 
    
    return Prefab("floaty_"..name, fn, assets, prefabs)
end 

return makefloaty("flint"), 
        makefloaty("rocks"),
        makefloaty("goldnugget"), 
        makefloaty("nitre")
        