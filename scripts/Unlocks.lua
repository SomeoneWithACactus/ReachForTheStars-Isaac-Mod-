local Mod = RegisterMod("Reach for the Stars", 1)
local game = Game()
local pool = game:GetItemPool()

UNLOCKS_SPRITES = {
    EXPLORER_BABY = "ExplorerBaby",
    SATURNS_PEACH = "SaturnPeach",
}


local ReversePolarizerUNLOCK

IsUnlocked = {
    TRUE = 1,
    FALSE = 0,
}

local function onStart(_)

    IsAchieveRender = false

end
Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)

function Mod:CheckIfItIsUnlock()
    if Mod:HasData() then
        
        local ModData = Mod:LoadData()

        ReversePolarizerUNLOCK = tonumber(ModData)
    end

    if ReversePolarizerUNLOCK == IsUnlocked.TRUE then
        game:GetHUD():ShowItemText("IS UNLOCKED")
    else
        game:GetHUD():ShowItemText("IS NOT UNLOCKED")

        pool:RemoveCollectible(RFTSItems.CALL_TO_BASE)
    end
    
end

Mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Mod.CheckIfItIsUnlock)


function SaveStateUnlocks()

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)
        local SaveData = ""

    
        SaveData = SaveData .. ReversePolarizerUNLOCK

        Mod:SaveData(SaveData)

    end

end


function AppearUnlockPopUp()

    local ACHIEVEMENT = Isaac.Spawn(EntityType.ENTITY_EFFECT,
                RFTSEffects.ACHIEVEMENT,
                0,
                Isaac.WorldToRenderPosition(Vector(450,800)),
                Vector.Zero,
                nil):ToEffect()

                ACHIEVEMENT.SpriteOffset = Vector(0, -125)

end


---@param npc EntityNPC
function Mod:KillFly(npc)

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:GetPlayerType() == RFTSCharacters.NOVA then 

            ---UNLOCK FOR REVERSE POLARIZER: BEAT ISAAC WITH NOVA
            
            if npc.Type == EntityType.ENTITY_FLY and ReversePolarizerUNLOCK == IsUnlocked.FALSE then

                AppearUnlockPopUp()

                SFX:Play(SoundEffect.SOUND_POWERUP1)

                IsAchieveRender = true 

                ReversePolarizerUNLOCK = IsUnlocked.TRUE

                SaveStateUnlocks()

            end

        end

    end
    
end

Mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, Mod.KillFly)