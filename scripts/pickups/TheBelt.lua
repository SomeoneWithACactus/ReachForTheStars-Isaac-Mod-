local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()
require("scripts.Items.NovasController")

local THEBELT_SPRITE = "gfx/005.300.04_thebelt.anm2"

---@param player EntityPlayer
function mod:onPostUpdate(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
            
            local data = entity:GetData()

            local sprite = entity:GetSprite()

            if entity.SubType == RFTSConsumables.THE_BELT then

                if sprite:GetFilename() ~= THEBELT_SPRITE and sprite:IsPlaying("Appear") then

                    sprite:Load(THEBELT_SPRITE, true)

                    sprite:Play("Appear")

                    sprite.Offset = Vector(0,5)
                    
                elseif sprite:GetFilename() ~= THEBELT_SPRITE and sprite:IsPlaying("Idle") then

                    sprite:Load(THEBELT_SPRITE, true)

                    sprite:Play("Idle")

                    sprite.Offset = Vector(0,5)

                end

            end

        end
        
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPostUpdate)


---@param player EntityPlayer
function mod:TheBeltOnUse(_, player)

    for i = 1, 8 do
                    
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC, 0, player.Position, Vector.Zero, player)

    end

    ZipZipLightBeam(player.Position)
    
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.TheBeltOnUse, RFTSConsumables.THE_BELT)