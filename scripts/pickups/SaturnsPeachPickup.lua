local Game = Game()

local TEAR_SPEED = 10


---@param player EntityPlayer
function Mod:SaturnPeachOnUpdate(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP ---Check if the Entity is a Pickup
        and (player.Position - entity.Position):Length() < player.Size + entity.Size then ---Check if player is touching the pickup
            
            if entity.Variant == RFTSPickups.SATURN_PEACH ---Check if it is the Saturn Peach Pickup
            and entity:GetSprite():IsPlaying("Idle") ---Check if it stopped appearing
            and entity:GetData().Picked == nil then ---Check if it has been picked up
                
                ---It has been picked up
                entity:GetData().Picked = true

                ---Stop collisions so it will not fly around
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                ---Play the collect sprite
                entity:GetSprite():Play("Collect", true)

                ShootTears(RFTSTears.PEACH_SEED, entity.Position, RFTSSounds.MUNCH, TEAR_SPEED, true, true, false,Color( ---Color of the SKYCRACK
                0.0, ---Red
                0.7, ---Green
                0.2, ---Blue
                1.0,
                0.0, ---Red Offset
                0.2, ---Green Offset
                0.2  ----Blue Offset
                ))

                

            end

        end

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == RFTSPickups.SATURN_PEACH then ---Check if it is the Stars
        
            local room = Game:GetRoom()
        
            if room:IsClear() then
                    
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, nil)

                entity:Remove()
                
            end
        
            if entity:GetSprite():IsEventTriggered("DropSound") then ---Check if the Drop Sound event is triggering
                    
                    SFX:Play(RFTSSounds.STAR_APPEAR) ---Play Sound

            end

        end

        ---Delete Star once Collected
        if entity.Type == EntityType.ENTITY_PICKUP ---Check if the entity is a Pickup
        and entity:GetData().Picked == true ---Check if it has been picked up
        and entity:GetSprite():GetFrame() == 6 then ---Check if the collect animation is done

            entity:Remove() ---Remove Pickup

        end

    end

end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Mod.SaturnPeachOnUpdate)