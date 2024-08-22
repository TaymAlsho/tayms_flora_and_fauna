local UpvalueHacker = GLOBAL.require("tools/upvaluehacker")

local function AddSlugHunt(self)
    local SpawnHuntedBeast = UpvalueHacker.GetUpvalue(self.OnDirtInvestigated, "SpawnHuntedBeast")
    local GetHuntedBeast = UpvalueHacker.GetUpvalue(SpawnHuntedBeast, "GetHuntedBeast")
    local ALTERNATE_BEASTS = UpvalueHacker.GetUpvalue(GetHuntedBeast, "ALTERNATE_BEASTS")
    table.insert(ALTERNATE_BEASTS, "gardenslug")
end

if GetModConfigData("gardenslug_hunt") then 
    AddComponentPostInit("hunter", AddSlugHunt)
end 