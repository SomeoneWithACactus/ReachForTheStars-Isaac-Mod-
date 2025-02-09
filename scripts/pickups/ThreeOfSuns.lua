local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local THREEOFSUNS_SPRITE = "gfx/005.300.03_threeofsuns.anm2"

---@param player EntityPlayer
function mod:onPostUpdate(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
            
            local data = entity:GetData()

            local sprite = entity:GetSprite()

            if entity.SubType == RFTSConsumables.THREE_OF_SUNS then

                if sprite:GetFilename() ~= THREEOFSUNS_SPRITE and sprite:IsPlaying("Appear") then

                    sprite:Load(THREEOFSUNS_SPRITE, true)

                    sprite:Play("Appear")

                    sprite.Offset = Vector(0,5)
                    
                elseif sprite:GetFilename() ~= THREEOFSUNS_SPRITE and sprite:IsPlaying("Idle") then

                    sprite:Load(THREEOFSUNS_SPRITE, true)

                    sprite:Play("Idle")

                    sprite.Offset = Vector(0,5)

                end

            end

        end
        
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPostUpdate)


---@param player EntityPlayer
function mod:ThreeSunsOnUse(_, player)

    local level = game:GetLevel()

    level:SetCanSeeEverything(true)

    player:AddGoldenKey()

    level:ApplyCompassEffect(false)

    SFX:Play(SoundEffect.SOUND_GOLDENKEY, 1, 2, false, 0.8)
    
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.ThreeSunsOnUse, RFTSConsumables.THREE_OF_SUNS)