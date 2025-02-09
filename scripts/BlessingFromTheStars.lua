local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()
require("scripts.Items.NovasController")


------BLESS OF THE ENLIGHTED------

function BLESSINGS:OnRoomRewardEnlighted(_, Pos)

    local level = game:GetLevel()

    if level:GetCurses() == BLESSINGS.BLESS_OF_THE_ENLIGHTED then ---50% Chance of Spawning a Star Pickup

        POSITION = Isaac.GetFreeNearPosition(Pos,32)
    
        local roll = math.random(100)

        if roll <= 50 then

            Isaac.Spawn(EntityType.ENTITY_PICKUP, RFTSPickups.STARS, 0, POSITION, Vector.Zero, player)

        end
    
    end

end

mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, BLESSINGS.OnRoomRewardEnlighted)


------BLESS OF THE SUN------

function BLESSINGS:onUpdateSun()

    for i = 0, game:GetNumPlayers() - 1 do

    local player = Isaac.GetPlayer(i)

    local level = game:GetLevel()

    if level:GetCurses() == BLESSINGS.BLESS_OF_THE_SUN then ---50% Chance of Spawning a Star Pickup

            for _, entity in ipairs(Isaac.GetRoomEntities()) do

                local roll = math.random(100)

                if entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() and roll <= 25 then
                    
                    Isaac.Spawn(EntityType.ENTITY_EFFECT,EffectVariant.CRACK_THE_SKY, 0, entity.Position, Vector.Zero, player)

                end
                
            end

    end
    

end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BLESSINGS.onUpdateSun)


------BLESS OF THE KNOWLEGE------

function BLESSINGS:onHitKnowlege(entity, amount, flag, source)

    local level = game:GetLevel()

    if level:GetCurses() == BLESSINGS.BLESS_OF_THE_KNOWLEGE then

        if entity.Type == EntityType.ENTITY_PLAYER then

            local roll = math.random(100)

            if roll <= 50 then

                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, entity.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)

            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, BLESSINGS.onHitKnowlege)


------BLESS OF THE EXPLORER------

function BLESSINGS:onNewSpecialRoomExplorer()

    local level = game:GetLevel()

    if level:GetCurses() == BLESSINGS.BLESS_OF_THE_EXPLORER then

        for i = 0, game:GetNumPlayers() - 1 do

            local player = Isaac.GetPlayer(i)

            local POSITION_PLAYER = Isaac.GetFreeNearPosition(player.Position, 50)

            local room = game:GetRoom()

            if room:IsFirstVisit() and room:GetType() ~= RoomType.ROOM_DEFAULT then
            
                Isaac.Spawn(EntityType.ENTITY_PICKUP, 0, 0, POSITION_PLAYER, Vector.Zero, player)

                player:AnimateHappy()

            end

        end

    end

    if level:GetCurses() == BLESSINGS.BLESS_OF_THE_ENLIGHTED then

        for i = 0, game:GetNumPlayers() - 1 do

            local player = Isaac.GetPlayer(i)

            local POSITION_PLAYER = Isaac.GetFreeNearPosition(player.Position, 50)

            local room = game:GetRoom()

            if room:IsFirstVisit() and room:GetType() == RoomType.ROOM_TREASURE then
            
                if player:GetPlayerType() ~= RFTSCharacters.NOVA then

                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Card.CARD_DICE_SHARD, POSITION_PLAYER, Vector.Zero, player)

                else

                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, RFTSConsumables.POCKET_8_BALL, POSITION_PLAYER, Vector.Zero, player)

                end

                ZipZipLightBeam(POSITION_PLAYER);

            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, BLESSINGS.onNewSpecialRoomExplorer)