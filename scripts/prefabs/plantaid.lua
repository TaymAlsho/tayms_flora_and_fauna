local assets =
{
	Asset("ANIM", "anim/plantaid.zip"),

    Asset("ATLAS", "images/inventoryimages/plantaid.xml"),
    Asset("IMAGE", "images/inventoryimages/plantaid.tex"),

    Asset("ATLAS", "images/inventoryimages/sterilized_plantaid.xml"),
    Asset("IMAGE", "images/inventoryimages/sterilized_plantaid.tex"),
}

--[[ why nerf plantaids in UM? 
in vanilla dst it's easy to heal while walking around on land via butterfly wings or spider glands 
these methods aren't good replacements for actual healing foods though, unless you take the time / resources to prepare them
i wanted plantaids to be the ocean equivalent of this
good to use while exploring, but difficult to dry enough of them to stockpile before they rot on your tiny boat
in uncompromising mode, however, some of these healing methods are nerfed! namely, butterfly wings only give one health
rather than gut their healing completely, i decided to lower the healing slightly and instead make plantaids give health gradually 
this should give them trouble replacing other healing options, but still be a nice find after fighting a rockjaw ]]
local function OnUse(inst, target)
	if target.components.debuffable ~= nil and target.components.health ~= nil and not target.components.health:IsDead() then
		target.configheal = inst.gradualheal
		target.components.debuffable:AddDebuff("confighealbuff", "confighealbuff") --this is a debuff from uncompromising mode
	end
end

local function plantaid()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("plantaid")
    inst.AnimState:SetBuild("plantaid")
    inst.AnimState:PlayAnimation("plantaid_ground")

    MakeInventoryFloatable(inst)

    inst:AddTag("dryable")
    inst:AddTag("icebox_valid")
    inst:AddTag("show_spoilage")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/plantaid.xml"
    inst.components.inventoryitem.imagename = "plantaid"

    --
    inst:AddComponent("healer")
    local taymid = KnownModIndex:GetModActualName("Taym's Flora and Fauna")
    if KnownModIndex:IsModEnabled("workshop-2039181790") and GetModConfigData("plantaid_nerf", taymid) then 
        inst.components.healer:SetHealthAmount(0) 
        inst.gradualheal = 10
        inst.components.healer.onhealfn = OnUse
    else 
        inst.components.healer:SetHealthAmount(TUNING.PLANTAID_HEALING)
    end 

    --
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PLANTAID_PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    --
    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct("sterilized_plantaid")
    inst.components.dryable:SetDryTime(TUNING.PLANTAID_DRY_TIME)
    inst.components.dryable:SetBuildFile("plantaid")
    inst.components.dryable:SetDriedBuildFile("plantaid")
    MakeHauntableLaunch(inst)

    return inst
end

local function sterilized_plantaid()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("plantaid")
    inst.AnimState:SetBuild("plantaid")
    inst.AnimState:PlayAnimation("plantaid_sterilized_ground")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    --
    inst:AddComponent("inspectable")

    --
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sterilized_plantaid.xml"
    inst.components.inventoryitem.imagename = "sterilized_plantaid"

    --
    inst:AddComponent("healer")
    local taymid = KnownModIndex:GetModActualName("Taym's Flora and Fauna")
    if KnownModIndex:IsModEnabled("workshop-2039181790") and GetModConfigData("plantaid_nerf", taymid) then 
        inst.components.healer:SetHealthAmount(0) 
        inst.gradualheal = 8
        inst.components.healer.onhealfn = OnUse
    else 
        inst.components.healer:SetHealthAmount(TUNING.PLANTAID_HEALING)
    end 

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("plantaid", plantaid, assets),
       Prefab("sterilized_plantaid", sterilized_plantaid, assets)
        