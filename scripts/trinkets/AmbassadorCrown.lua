local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

function mod:AmbassadorCrownOnNewRoom()

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(RFTSTrinkets.AMBASSADORS_CROWN) then
        
        local room = game:GetRoom()

        if room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() then

            SFX:Play(SoundEffect.SOUND_POWERUP1)

            player:AnimateHappy()

            for i = 1, 3 do
            
                local roll = math.random(1,4)

                if roll == 1 then
                
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_KEY,
                            KeySubType.KEY_NORMAL,
                            player.Position,
                            Vector((math.random(40)-21)/4,(math.random(40)-21)/4),
                            player)

                elseif roll == 2 then
                
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COIN,
                            CoinSubType.COIN_PENNY,
                            player.Position,
                            Vector((math.random(40)-21)/4,(math.random(40)-21)/4),
                            player)

                elseif roll == 3 then
                
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            Card.CARD_FOOL,
                            player.Position,
                            Vector((math.random(40)-21)/4,(math.random(40)-21)/4),
                            player)

                elseif roll == 4 then
                
                    Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            Card.CARD_WORLD,
                            player.Position,
                            Vector((math.random(40)-21)/4,(math.random(40)-21)/4),
                            player)

                end
            
            end

            local roll_item = math.random(1, 50)

            if roll_item == 1 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_SOY_MILK)

            elseif roll_item == 2 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_ALMOND_MILK)
                
            elseif roll_item == 3 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_POLYPHEMUS)
                
            elseif roll_item == 4 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_BIRDS_EYE)
                
            elseif roll_item == 5 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_GHOST_PEPPER)
                
            elseif roll_item == 6 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_TINY_PLANET)
                
            elseif roll_item == 7 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_DEAD_BIRD)

                
            elseif roll_item == 8 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_ANGRY_FLY)

                
            elseif roll_item == 9 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_GODHEAD)

                
            elseif roll_item == 10 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_PLUTO)

                
            elseif roll_item == 11 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_TELEPORT)

                
            elseif roll_item == 12 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_TELEPORT_2)

                
            elseif roll_item == 13 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_CURSED_EYE)

                
            elseif roll_item == 14 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_TECH_X)

                
            elseif roll_item == 15 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_GAMEKID)

                
            elseif roll_item == 16 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_MONSTRANCE)

                
            elseif roll_item == 17 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_SALVATION)

                
            elseif roll_item == 18 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_INFAMY)

                
            elseif roll_item == 19 then
                
                RerollColectible(CollectibleType.COLLECTIBLE_MINI_MUSH)

                
            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.AmbassadorCrownOnNewRoom)