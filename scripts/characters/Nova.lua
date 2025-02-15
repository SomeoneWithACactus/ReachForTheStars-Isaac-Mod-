local Mod = RegisterMod("Reach-for-the-Stars", 1)
local Game = Game()
local pool = Game:GetItemPool()

---@param player EntityPlayer
function Mod:NovaCostumeInit(player)
    if player:GetPlayerType() ~= RFTSCharacters.NOVA then
        
        pool:RemoveTrinket(RFTSTrinkets.AMBASSADORS_CROWN)
        pool:RemoveTrinket(RFTSTrinkets.ALIEN_WORM)
        pool:RemoveTrinket(RFTSTrinkets.LAZY_ALIEN_WORM)
        pool:RemoveTrinket(RFTSTrinkets.MINI_MINILASER)
        pool:RemoveTrinket(RFTSTrinkets.SKY_LIGHTS)
        pool:RemoveTrinket(RFTSTrinkets.STAR_GAZING)

        return
    end
    
    player:AddNullCostume(RFTSCostumes.NOVA_BODY)
    
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Mod.NovaCostumeInit)

---@param player EntityPlayer
function Mod:NovaInit(player)
    if player:GetPlayerType() ~= RFTSCharacters.NOVA then
        return
    end

    player:SetPocketActiveItem(RFTSItems.CALL_TO_BASE, ActiveSlot.SLOT_POCKET, true)
    
end

Mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, Mod.NovaInit)


function Mod:onStart()
    for i = 0, Game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

    if player:GetPlayerType() ~= RFTSCharacters.NOVA then
        return
    end

    if Game:IsGreedMode() == false then

        player.Position = Vector(320,350)

    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then

        local blessing_roll = math.random(1,10)

        if blessing_roll <= 3 then
            
            BlessingEffect("BLESSING OF THE ENLIGHTED", "Open your eyes to the stars!", LevelCurse.CURSE_OF_BLIND, BLESSINGS.BLESS_OF_THE_ENLIGHTED) 

        end

    end

    end
end
Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.onStart)

NOVA_STATS = {
    DAMAGE = 1,
    MAXFIREDELAY = 0.90,
    SHOTSPEED = 0.25,
    TEAR_DMG_MULT = 0.15,
    TEAR_FRICTION = 1.025,
    TEAR_LENGT = 100
}

---@param player EntityPlayer
function Mod:onGreenTears(player, flag)
    if player:GetPlayerType() ~= RFTSCharacters.NOVA then
        return
    end

    if flag == CacheFlag.CACHE_TEARCOLOR then

        player.TearColor = Color(
            0.0, ---Red
            0.8, ---Green
            0.8, ---Blue
            1.0,
            0.0, ---Red Offset
            0.5, ---Green Offset
            0.0  ----Blue Offset
            )
    end

    if flag == CacheFlag.CACHE_DAMAGE then

        player.Damage = player.Damage - NOVA_STATS.DAMAGE

        player.Damage = player.Damage * player.ShotSpeed

        player.MaxFireDelay = player.MaxFireDelay * NOVA_STATS.MAXFIREDELAY

    end

    if flag == CacheFlag.CACHE_SHOTSPEED then

        player.ShotSpeed = player.ShotSpeed + NOVA_STATS.SHOTSPEED

    end

end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.onGreenTears)

--@param tear EntityTear
--function Mod:NovasTear(tear)

--    local player = Isaac.GetPlayer(0)

--    if player:GetPlayerType() ~= RFTSCharacters.NOVA and player:HasCollectible(CollectibleType.COLLECTIBLE_LACHRYPHAGY) == false then
--        return
--    end

--    tear.Friction = NOVA_STATS.TEAR_FRICTION

--    if (tear.Position - player.Position):Length() > NOVA_STATS.TEAR_LENGT then

--        tear.CollisionDamage = tear.CollisionDamage + NOVA_STATS.TEAR_DMG_MULT

--    end
    
--end

--Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, Mod.NovasTear)


