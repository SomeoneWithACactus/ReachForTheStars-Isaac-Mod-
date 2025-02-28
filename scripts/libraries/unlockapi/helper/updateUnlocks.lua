local game = Game()

--Constants
UnlockAPI.Constants.TABLE_NAME_TO_CALLBACK = {
    TaintedCharacters = UnlockAPI.Enums.ModCallbacksCustom.MC_UNLOCK_TAINTED,
    Collectibles = UnlockAPI.Enums.ModCallbacksCustom.MC_UNLOCK_COLLECTIBLE,
    Trinkets = UnlockAPI.Enums.ModCallbacksCustom.MC_UNLOCK_TRINKET,
    Entities = UnlockAPI.Enums.ModCallbacksCustom.MC_UNLOCK_ENTITY,
    Cards = UnlockAPI.Enums.ModCallbacksCustom.MC_UNLOCK_CARD,
    CustomEntry = UnlockAPI.Enums.ModCallbacksCustom.MC_UNLOCK_CUSTOMENTRY,
}

--Function (helper^2)
local function GetRequirementsToAdd(requirementType)
    local requirementsToAdd = {}
    table.insert(requirementsToAdd, requirementType)

    if requirementType ~= UnlockAPI.Enums.RequirementType.TAINTED and game.Difficulty == Difficulty.DIFFICULTY_HARD or game.Difficulty == Difficulty.DIFFICULTY_GREEDIER then
        table.insert(requirementsToAdd, requirementType | UnlockAPI.Enums.RequirementType.HARDMODE)
    end

    return requirementsToAdd
end

--Function (helper)
function UnlockAPI.Helper.UpdateUnlocks(requirementType, specifiedPlayer)
    local newRequirementsFulfiled = {}

    local requirementsToAdd = GetRequirementsToAdd(requirementType)
    for _, entityPlayer in pairs(Isaac.FindByType(EntityType.ENTITY_PLAYER)) do

        local playerUnlockData, playerName = UnlockAPI.Helper.GetPlayerUnlockData(specifiedPlayer or entityPlayer:ToPlayer())
        for _, requirementId in pairs(requirementsToAdd) do

            Isaac.RunCallbackWithParam(UnlockAPI.Enums.ModCallbacksCustom.MC_BEAT_REQUIREMENT, requirementId, entityPlayer:ToPlayer(), requirementId)

            local requirementIdString = tostring(math.floor(requirementId))

            if not playerUnlockData[requirementIdString] then
                table.insert(newRequirementsFulfiled, { UnlockData = playerUnlockData, Requirement = requirementId, PlayerName = playerName })
                playerUnlockData[requirementIdString] = true
            end
        end

        if specifiedPlayer then break end
    end

    local alreadyUnlockedData = {} --To fix "the callback runs twice" problem
    for _, tableName in pairs(UnlockAPI.Constants.TABLE_NAME_TO_CALLBACK) do alreadyUnlockedData[tableName] = {} end

    for _, fulfilledData in pairs(newRequirementsFulfiled) do
        for _, achievementData in pairs(UnlockAPI.Helper.MergeTablesInside(UnlockAPI.Unlocks)) do

            if type(achievementData.UnlockRequirements) == "string" or (achievementData.UnlockRequirements or 0) & fulfilledData.Requirement ~= fulfilledData.Requirement then goto continue end
            if alreadyUnlockedData[achievementData.AchievementID] or not (fulfilledData.PlayerName == achievementData.PlayerName and UnlockAPI.Helper.FulfilledAllRequirements(achievementData.UnlockRequirements, fulfilledData.UnlockData)) then goto continue end

            UnlockAPI.Helper.ShowUnlock(achievementData.AchievementGfx)
            Isaac.RunCallbackWithParam(achievementData.UnlockCallback, achievementData.ID, achievementData)

            alreadyUnlockedData[achievementData.AchievementID] = true

            ::continue::
        end
    end
end