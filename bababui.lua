local json = require("json")

include("scripts.libraries.unlockapi.core")




UnlockAPI.Library:RegisterPlayer("Reach-for-the-Stars", "Nova")

UnlockAPI.Library:RegisterCollectible("Nova",
RFTSItems.SATURN_PEACH,
UnlockAPI.Enums.RequirementType.MOMSHEART,
"gfx/ui/achievement/achieve_02_saturnspeach.png")  --Locks it only behind MOM

UnlockAPI.Library:RegisterCollectible("Nova",
RFTSItems.SLEEP_DEPRIVED,
UnlockAPI.Enums.RequirementType.SATAN,
"!!NOPAPER!!Sleep Deprived Unlocked!")  --Locks it only behind SATAN

UnlockAPI.Library:RegisterTrinket("Nova",
RFTSTrinkets.MINI_MINILASER,
UnlockAPI.Enums.RequirementType.ISAAC,
"!!NOPAPER!!Mini Mini Laser Unlocked!")  --Locks it only behind ISAAC

UnlockAPI.Library:RegisterCard("Nova",
RFTSConsumables.BLESSING_FROM_THE_STARS,
UnlockAPI.Enums.RequirementType.BLUEBABY,
"!!NOPAPER!!Nova feels Blessed!") --Locks it only behind ???

UnlockAPI.Library:RegisterCollectible("Nova",
RFTSItems.SLEEP_DEPRIVED,
UnlockAPI.Enums.RequirementType.SATAN,
"!!NOPAPER!!Sleep Deprived Unlocked!")  --Locks it only behind SATAN

UnlockAPI.Library:RegisterCollectible("Nova",
RFTSItems.UFO_BOMBS,
UnlockAPI.Enums.RequirementType.LAMB,
"!!NOPAPER!!UFO Bombs Unlocked!")  --Locks it only behind LAMB


---@param player EntityPlayer
Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)

    if player:GetPlayerType() == RFTSCharacters.NOVA and UnlockAPI.Library:IsCardUnlocked(RFTSConsumables.BLESSING_FROM_THE_STARS) then

        player:AddCard(RFTSConsumables.BLESSING_FROM_THE_STARS)

    end
end)



Mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_, isContinued)

    if UnlockAPI.Library:IsCollectibleUnlocked(RFTSItems.SATURN_PEACH) == false then 

    game:GetItemPool():RemoveCollectible(RFTSItems.SATURN_PEACH)

    end

    if UnlockAPI.Library:IsCollectibleUnlocked(RFTSItems.SLEEP_DEPRIVED) == false then 

        game:GetItemPool():RemoveCollectible(RFTSItems.SLEEP_DEPRIVED)
    
    end

    if UnlockAPI.Library:IsTrinketUnlocked(RFTSTrinkets.MINI_MINILASER) == false then 

        game:GetItemPool():RemoveTrinket(RFTSTrinkets.MINI_MINILASER)
    
    end

    if UnlockAPI.Library:IsCollectibleUnlocked(RFTSItems.UFO_BOMBS) == false then 

        game:GetItemPool():RemoveCollectible(RFTSItems.UFO_BOMBS)
    
    end

end)



--Save manager (This is important, TRY TO UNDERSTAND HOW IT WORKS WITH UNLOCKAPI, NOT COPY IT) (XD)
local function LoadData(_, isContinue)
    local savedata = {}
    if Mod:HasData() then
        savedata = json.decode(Mod:LoadData())
    else
        savedata = {}
    end

    if not isContinue then
        Mod.Save = {}
    else
        Mod.Save = savedata.Save
    end
    UnlockAPI.Library:LoadSaveData(savedata.UnlockData)
end

local function SaveData()
    if Isaac.GetPlayer().FrameCount == 0 then return end
    local savedata = {}
    savedata.Save = Mod.Save
    savedata.UnlockData = UnlockAPI.Library:GetSaveData("Reach-for-the-Stars")
    Mod:SaveData(json.encode(savedata))

end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, LoadData)
Mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, SaveData)
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SaveData)

