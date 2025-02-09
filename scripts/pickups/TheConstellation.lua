local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local THECONSTELLATION_SPRITE = "gfx/005.300.05_theconstellation.anm2"

local AMOUNT = 0;
local doConstellationBuff = false

---@param player EntityPlayer
function mod:onPostUpdate(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
            
            local data = entity:GetData()

            local sprite = entity:GetSprite()

            if entity.SubType == RFTSConsumables.THE_CONSTELLATION then

                if sprite:GetFilename() ~= THECONSTELLATION_SPRITE and sprite:IsPlaying("Appear") then

                    sprite:Load(THECONSTELLATION_SPRITE, true)

                    sprite:Play("Appear")

                    sprite.Offset = Vector(0,5)
                    
                elseif sprite:GetFilename() ~= THECONSTELLATION_SPRITE and sprite:IsPlaying("Idle") then

                    sprite:Load(THECONSTELLATION_SPRITE, true)

                    sprite:Play("Idle")

                    sprite.Offset = Vector(0,5)

                end

            end

        end
        
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPostUpdate)


---@param player EntityPlayer
function mod:TheConstellationOnUse(_, player)

    local itemCount = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_JUPITER, true) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_LUNA, true)
    + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MARS, true) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_MERCURIUS, true)
    + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_NEPTUNUS, true) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_PLUTO, true)
    + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SATURNUS, true) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_TERRA, true)
    + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_URANUS, true) + player:GetCollectibleNum(CollectibleType.COLLECTIBLE_VENUS, true)
    + player:GetCollectibleNum(RFTSItems.ERIS, true) + player:GetCollectibleNum(RFTSItems.CELESTIAL_MASK, true)

    for i = 0, itemCount do
        
        AMOUNT = AMOUNT + 2.5;

    end

    doConstellationBuff = true

    SFX:Play(RFTSSounds.CONSTELLATION_HIT)

    game:ShakeScreen(5)
    
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.TheConstellationOnUse, RFTSConsumables.THE_CONSTELLATION)

---@param player EntityPlayer
function mod:OnConstellationUpdate(player)

    if doConstellationBuff == true then
        
        if AMOUNT > 0.01 then
            
            AMOUNT = AMOUNT - 0.01;

        else doConstellationBuff = false end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnConstellationUpdate)

---@param player EntityPlayer
function mod:OnConstellationCache(player, flag)

    if flag == CacheFlag.CACHE_DAMAGE then
        
        player.Damage = player.Damage + AMOUNT;

    end
    
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnConstellationCache)