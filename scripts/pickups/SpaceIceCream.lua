local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

local IceCreamEaten = 0

local function onStart(_)
    IceCreamEaten = 0
    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)

    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)

---@param player EntityPlayer
function mod:SpaceIcreCream(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP ---Check if the Entity is a Pickup
        and (player.Position - entity.Position):Length() < player.Size + entity.Size then ---Check if player is touching the pickup
            
            if entity.Variant == RFTSPickups.SPACE_ICRECREAM  ---Check if it is the Stars
            and entity:GetSprite():IsPlaying("Idle") ---Check if it stopped appearing
            and entity:GetData().Picked == nil then ---Check if it has been picked up
                
                ---It has been picked up
                entity:GetData().Picked = true

                ---Stop collisions so it will not fly around
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                ---Play the collect sprite
                entity:GetSprite():Play("Collect", true)

                if entity.SubType == SPACE_ICE_CREAM_SUBTYPE.NAPOLITAN then

                    game:GetHUD():ShowItemText("NAPOLITAN SPACE ICE CREAM", "Hearts Up!")

                    local roll = math.random(1,3)

                    if roll == 1 then

                        if player:GetHearts() ~= player:GetMaxHearts() then
                        
                            player:AddHearts(1)

                        else

                            player:AddBoneHearts(1) 

                        end

                    elseif roll == 2 then
                        
                        player:AddSoulHearts(1)
                        
                    elseif roll == 3 then
                        
                        player:AddBlackHearts(1)
                        
                    end
                    
                elseif entity.SubType == SPACE_ICE_CREAM_SUBTYPE.CHOCOMINT then

                    game:GetHUD():ShowItemText("CHOCOMINT SPACE ICE CREAM", "Luck Up!")

                    player.Luck = player.Luck + 0.5

                    player:AddCacheFlags(CacheFlag.CACHE_LUCK)

                    player:EvaluateItems()

                    if IceCreamEaten == 0 then
                        
                        Isaac.Spawn(EntityType.ENTITY_PICKUP, RFTSPickups.SPACE_ICRECREAM, SPACE_ICE_CREAM_SUBTYPE.CHOCOMINT, player.Position, Vector.Zero, player)

                    end

                    IceCreamEaten = IceCreamEaten + 1
                    
                elseif entity.SubType == SPACE_ICE_CREAM_SUBTYPE.SANDWICH then

                    game:GetHUD():ShowItemText("SPACE ICE CREAM SANDWICH", "Friends Up!")

                    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC, 0, player.Position, Vector.Zero, player)
                    
                end

                SFX:Play(RFTSSounds.MUNCH)

                SFX:Play(SoundEffect.SOUND_PAPER_IN)

                

            end

        end

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == RFTSPickups.SPACE_ICRECREAM
        and entity:GetSprite():IsEventTriggered("DropSound") then ---Check if the Drop Sound event is triggering
                
            SFX:Play(RFTSSounds.SPLAT) ---Play Sound

        end

        ---Delete Star once Collected
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == RFTSPickups.SPACE_ICRECREAM
        and entity:GetData().Picked == true ---Check if it has been picked up
        and entity:GetSprite():GetFrame() == 6 then ---Check if the collect animation is done

            entity:Remove() ---Remove Pickup

        end

    end

end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.SpaceIcreCream)

ICECREAMS = {
    LUCK = 0.25
}

---@param player EntityPlayer
function mod:IceCreamCache(player, flag)

    if flag == CacheFlag.CACHE_LUCK then

        local LuckToAdd = ICECREAMS.LUCK * IceCreamEaten
                    
        player.Luck = player.Luck + LuckToAdd

    end

    if flag == CacheFlag.CACHE_FIREDELAY then
                    
        player.MaxFireDelay = player.MaxFireDelay - 0.5

    end


         
    
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.IceCreamCache)