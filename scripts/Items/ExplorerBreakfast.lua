local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local DAMAGE_BUFF = {
    MILKY_WAY_MILK = 0.90,
    SOY_MILK = 0.50,
    CHOCOMILK = 0.80,
    ALMOND_MILK = 0.30,
    THE_MILK = 0.15,
}

---@param player EntityPlayer
function mod:ExplorerMilkBuffsCacheEvaluation(player,flag)
    if player:HasCollectible(RFTSItems.EXPLORER_BREAKFAST) then

        if flag == CacheFlag.CACHE_DAMAGE then

            if player:HasCollectible(RFTSItems.MILKY_WAY_MILK) then

            player.Damage = player.Damage + DAMAGE_BUFF.MILKY_WAY_MILK

            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_SOY_MILK) then

                player.Damage = player.Damage + DAMAGE_BUFF.SOY_MILK
    
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_CHOCOLATE_MILK) then

                player.Damage = player.Damage + DAMAGE_BUFF.CHOCOMILK
    
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then

                player.Damage = player.Damage + DAMAGE_BUFF.ALMOND_MILK
    
            end

            if player:HasCollectible(CollectibleType.COLLECTIBLE_MILK) then

                player.Damage = player.Damage + DAMAGE_BUFF.THE_MILK
    
            end

        end

    end

end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.ExplorerMilkBuffsCacheEvaluation)