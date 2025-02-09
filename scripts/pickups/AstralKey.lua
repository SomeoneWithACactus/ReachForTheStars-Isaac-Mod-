local Game = Game()


---@param player EntityPlayer
function Mod:AstralKeyUpdate(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP ---Check if the Entity is a Pickup
        and (player.Position - entity.Position):Length() < player.Size + entity.Size then ---Check if player is touching the pickup
            
            if entity.Variant == PickupVariant.PICKUP_KEY and entity.SubType == RFTSPickups.ASTRAL_KEY ---Check if it is the Stars
            and entity:GetSprite():IsPlaying("Idle") ---Check if it stopped appearing
            and entity:GetData().Picked == nil then ---Check if it has been picked up
                
                ---It has been picked up
                entity:GetData().Picked = true

                ---Stop collisions so it will not fly around
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                ---Play the collect sprite
                entity:GetSprite():Play("Collect", true)
            
                ---Add Wisp
                player:AddWisp(CollectibleType.COLLECTIBLE_RED_KEY, player.Position)

                SFX:Play(SoundEffect.SOUND_KEYPICKUP_GAUNTLET, 1, 2, false, 0.8) ---Play Sound

            end

        end

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_KEY
        and entity.SubType == RFTSPickups.ASTRAL_KEY ---Check if it is the Stars
        and entity:GetSprite():IsEventTriggered("DropSound") then ---Check if the Drop Sound event is triggering
                
                SFX:Play(SoundEffect.SOUND_KEY_DROP0, 1, 2, false, 0.8) ---Play Sound

        end

        ---Delete Star once Collected
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_KEY
        and entity.SubType == RFTSPickups.ASTRAL_KEY ---Check if the entity is a Pickup
        and entity:GetData().Picked == true ---Check if it has been picked up
        and entity:GetSprite():GetFrame() == 6 then ---Check if the collect animation is done

            entity:Remove() ---Remove Pickup

        end

    end

end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Mod.AstralKeyUpdate)