local Game = Game()

function AddCoinAmount(amount,sfx)

    for i = 0, Game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        ---Play sound effect on pick up
        SFX:Play(sfx)

        player:AddCoins(amount)

    end
    
end


---@param player EntityPlayer
function Mod:SpaceCurrencyUpdate(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP ---Check if the Entity is a Pickup
        and (player.Position - entity.Position):Length() < player.Size + entity.Size then ---Check if player is touching the pickup
            
            if entity.Variant == PickupVariant.PICKUP_COIN and entity.SubType == RFTSPickups.SPACE_CURRENCY ---Check if it is the Stars
            and entity:GetData().Picked == nil then ---Check if it has been picked up
                
                ---It has been picked up
                entity:GetData().Picked = true

                ---Stop collisions so it will not fly around
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                ---Play the collect sprite
                entity:GetSprite():Play("Collect", true)

                ---Add a Star
                local roll = math.random(1,5)

                if roll == 1 then
                    
                    AddCoinAmount(1, SoundEffect.SOUND_PENNYPICKUP)

                elseif roll == 2 then
                    
                    AddCoinAmount(2, RFTSSounds.STAR_PICKUP)

                elseif roll == 3 then
                    
                    AddCoinAmount(5, SoundEffect.SOUND_NICKELPICKUP)

                elseif roll == 4 then
                    
                    AddCoinAmount(10, SoundEffect.SOUND_DIMEPICKUP)

                elseif roll == 5 then

                    SFX:Play(SoundEffect.SOUND_GOLD_HEART)
                    
                    player:AddWisp(CollectibleType.COLLECTIBLE_WOODEN_NICKEL, player.Position, false, false)

                end

            end

        end

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COIN
        and entity.SubType == RFTSPickups.SPACE_CURRENCY ---Check if it is the Stars
        and entity:GetSprite():IsEventTriggered("DropSound") then ---Check if the Drop Sound event is triggering
                
                SFX:Play(SoundEffect.SOUND_NICKELDROP) ---Play Sound

        end

        ---Delete Star once Collected
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COIN
        and entity.SubType == RFTSPickups.SPACE_CURRENCY ---Check if the entity is a Pickup
        and entity:GetData().Picked == true ---Check if it has been picked up
        and entity:GetSprite():GetFrame() == 6 then ---Check if the collect animation is done

            entity:Remove() ---Remove Pickup

        end

    end

end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Mod.SpaceCurrencyUpdate)