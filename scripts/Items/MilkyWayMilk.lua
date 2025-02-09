local MILKY_WAY_DAMAGE_MULT = 0.35
local MILKY_WAY_TEARS_MULT = 0.50

---@param player EntityPlayer
function Mod:MilkEvaluateCache(player,flag)
    if player:HasCollectible(RFTSItems.MILKY_WAY_MILK) then

        if flag == CacheFlag.CACHE_DAMAGE then

            player.Damage = player.Damage * MILKY_WAY_DAMAGE_MULT

        end

        if flag == CacheFlag.CACHE_FIREDELAY then
            
            player.MaxFireDelay = player.MaxFireDelay * MILKY_WAY_TEARS_MULT

        end
        

        if flag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_HOMING
        end

        if flag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = Color(
                0.8, ---Red
                0.0, ---Green
                0.5, ---Blue
                1.0,
                0.5, ---Red Offset
                0.0, ---Green Offset
                0.3  ----Blue Offset
                )
        end
    end
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.MilkEvaluateCache)