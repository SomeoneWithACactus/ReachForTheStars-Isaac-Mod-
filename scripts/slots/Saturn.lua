local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

local room = game:GetRoom()
local level = game:GetLevel()

local ACTIVATE_PORTAL = {
    TREASURE = false,
    BOSS = false,
}

local SATURN_CHANCES = {
    STAR_NEEDED = 3,
    STARS_RECIEVED = 0,
    STATE_OF_PAYOUT = 1,
    MAX_PAYOUT = 5
}

local function onStart(_)

    SATURN_CHANCES = {
        STAR_NEEDED = 3,
        STARS_RECIEVED = 0,
        STATE_OF_PAYOUT = 1,
        MAX_PAYOUT = 5
    }

    ACTIVATE_PORTAL = {
        TREASURE = false,
        BOSS = false,
    }
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)


function mod:onNewLevel()

    ACTIVATE_PORTAL = {
        TREASURE = false,
        BOSS = false,
    }

    SATURN_CHANCES = {
        STAR_NEEDED = 3,
        STARS_RECIEVED = 0,
        STATE_OF_PAYOUT = 1,
        MAX_PAYOUT = 5
    }

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.PORTAL_TELEPORT then
            
            entity:Remove()

        end
        
    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)


function CheckIfPortalIsAvaliable()

    if room:GetType() == RoomType.ROOM_BOSS then
        
        ACTIVATE_PORTAL.BOSS = true

    elseif game:GetFrameCount() < 2 then

        ACTIVATE_PORTAL.BOSS = false

    end

    if room:GetType() == RoomType.ROOM_TREASURE then
    
        ACTIVATE_PORTAL.TREASURE = true

    elseif game:GetFrameCount() < 2 then

        ACTIVATE_PORTAL.TREASURE = false

    end

    
end

function mod:onRoom()

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        
        if player:GetPlayerType() ~= RFTSCharacters.NOVA then
            return
        end

        local NewRoom = true

        CheckIfPortalIsAvaliable()

        for _, entity in ipairs(Isaac.GetRoomEntities()) do

            if entity.Type ~= RFTSNpc.SATURN and level:GetCurrentRoomIndex() == level:GetStartingRoomIndex() and game:IsGreedMode() == false and NewRoom == true then

                local Saturn = Isaac.Spawn(
                    RFTSNpc.SATURN,
                    0,
                    0,
                    room:GetCenterPos(),
                    Vector.Zero,
                    nil
                )


                local beggarFlag = EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS

                Saturn:ClearEntityFlags(Saturn:GetEntityFlags())

                Saturn:AddEntityFlags(beggarFlag)

                Saturn.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

                if ACTIVATE_PORTAL.TREASURE == true then
                
                    Isaac.Spawn(
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.PORTAL_TELEPORT,
                    0,
                    Vector(105,380),
                    Vector.Zero,
                    nil
                )
    
                end
    
                if ACTIVATE_PORTAL.BOSS == true then
                    
                    Isaac.Spawn(
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.PORTAL_TELEPORT,
                    1,
                    Vector(535,380),
                    Vector.Zero,
                    nil
                )

                end 

                NewRoom = false

            elseif entity.Type ~= RFTSNpc.SATURN and room:GetType() == RoomType.ROOM_SHOP and game:IsGreedMode() == true and NewRoom == true then

                local Saturn = Isaac.Spawn(
                    RFTSNpc.SATURN,
                    0,
                    0,
                    room:GetCenterPos(),
                    Vector.Zero,
                    nil
                )


                local beggarFlag = EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS

                Saturn:ClearEntityFlags(Saturn:GetEntityFlags())

                Saturn:AddEntityFlags(beggarFlag)

                Saturn.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY



                NewRoom = false

            end
        
        end

    end

end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onRoom)



---INITIATION OF BEGGAR
function mod:BeggarInit(entity)

    ---Do this so it will not die from other dudes
    entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.BeggarInit, RFTSNpc.SATURN)



function mod:SaturnOnUpdate(Saturn)

    local Saturn = Saturn:ToNPC()

    local beggarFlag = EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS

    if Saturn:GetEntityFlags() ~= beggarFlag then

        Saturn:ClearEntityFlags(Saturn:GetEntityFlags())

        Saturn:AddEntityFlags(beggarFlag)

        Saturn.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

    end


    local data = Saturn:GetData()

    ---It can collide and sightly move on collision
    if data.Position == nil then data.Position = Saturn.Position end
    Saturn.Velocity = data.Position - Saturn.Position

    local player = Isaac.GetPlayer(0)

    local sprite = Saturn:GetSprite()

    local PLAYER_STARS = player:GetData().Stars

    local POSITION = Isaac.GetFreeNearPosition(Saturn.Position, 32)

    
    if Saturn.Type == RFTSNpc.SATURN then
        
        if Saturn.State == BeggarState.IDLE then
            
            if Saturn.StateFrame == 0 then

                if SATURN_CHANCES.STARS_RECIEVED < 1 then

                    sprite:Play("Idle", true)

                elseif SATURN_CHANCES.STARS_RECIEVED == 1 then

                    sprite:Play("Idle2", true)

                elseif SATURN_CHANCES.STARS_RECIEVED == 2 then

                    sprite:Play("Idle3", true)

                end

            end

            if (Saturn.Position - player.Position):Length() <= Saturn.Size + player.Size then ---Collide: Paying the Beggar

                if PLAYER_STARS > 0 then

                    SFX:Play(SoundEffect.SOUND_SCAMPER, 1, 0, false, 1) ---Sound Effect Paying
    
                    player:GetData().Stars = player:GetData().Stars - 1 ---Take a Star
                        
                    Saturn.State = BeggarState.PAYPRIZE

                    Saturn.StateFrame = - 1

                    SATURN_CHANCES.STARS_RECIEVED = SATURN_CHANCES.STARS_RECIEVED + 1

                end

            end

        elseif Saturn.State == BeggarState.PAYPRIZE then ---ANIMATE PAY OFF

                if Saturn.StateFrame == 0 then ---Start Animation on Frame 1
        
                    sprite:Play("PayStar", true)
        
                end
                
                if sprite:IsFinished("PayStar") and SATURN_CHANCES.STARS_RECIEVED == SATURN_CHANCES.STAR_NEEDED then ---Once the animation is done start the STATE PRIZE
        
                    Saturn.State = BeggarState.PRIZE
        
                    Saturn.StateFrame = - 1
                    
                elseif sprite:IsFinished("PayStar") and SATURN_CHANCES.STARS_RECIEVED <= SATURN_CHANCES.STAR_NEEDED then

                    Saturn.State = BeggarState.IDLE
        
                    Saturn.StateFrame = - 1

                    SFX:Play(SoundEffect.SOUND_ITEMRECHARGE)

                end


        elseif Saturn.State == BeggarState.PRIZE then
            
                if Saturn.StateFrame == 0 then

                    sprite:Play("Payout", true) ---Animate Giving you the Prize
            
                elseif sprite:IsEventTriggered("Payout") then

                    player:AnimateHappy()

                    if SATURN_CHANCES.STATE_OF_PAYOUT == 1 then

                        local Roll = Saturn:GetDropRNG():RandomInt(100) ---Roll a Dice: What will it be your 
                        
                        if Roll <= 50 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_KEY,
                            0,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll > 50 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COIN,
                            RFTSPickups.SPACE_CURRENCY,
                            POSITION,
                            Vector(0, 0),
                            player)

                        end

                    elseif SATURN_CHANCES.STATE_OF_PAYOUT == 2 then

                        local Roll = Saturn:GetDropRNG():RandomInt(100) ---Roll a Dice: What will it be your 
                        
                        if Roll < 15 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_KEY,
                            RFTSPickups.ASTRAL_KEY,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 50 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COIN,
                            RFTSPickups.SPACE_CURRENCY,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 75 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.THE_BELT,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 100 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.THE_CONSTELLATION,
                            POSITION,
                            Vector(0, 0),
                            player)

                        end

                    elseif SATURN_CHANCES.STATE_OF_PAYOUT == 3 then

                        local Roll = Saturn:GetDropRNG():RandomInt(100) ---Roll a Dice: What will it be your 
                        
                        if Roll < 25 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            Card.CARD_STARS,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 50 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            RFTSPickups.SPACE_ICRECREAM,
                            SPACE_ICE_CREAM_SUBTYPE.CHOCOMINT,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 75 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            RFTSPickups.SPACE_ICRECREAM,
                            SPACE_ICE_CREAM_SUBTYPE.NAPOLITAN,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 100 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            RFTSPickups.SPACE_ICRECREAM,
                            SPACE_ICE_CREAM_SUBTYPE.SANDWICH,
                            POSITION,
                            Vector(0, 0),
                            player)

                        end

                    elseif SATURN_CHANCES.STATE_OF_PAYOUT == 4 then

                        local Roll = Saturn:GetDropRNG():RandomInt(100) ---Roll a Dice: What will it be your 
                        
                        if Roll < 50 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.BLESSING_FROM_THE_STARS,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 75 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.POCKET_8_BALL,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 100 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.THREE_OF_SUNS,
                            POSITION,
                            Vector(0, 0),
                            player)

                        end

                    elseif SATURN_CHANCES.STATE_OF_PAYOUT == 5 then

                        local Roll = math.min(Saturn:GetDropRNG():RandomInt(100) + (player:GetCollectibleNum(RFTSItems.EXPLORER_BREAKFAST) * 5), 100) ---Roll a Dice: What will it be your 
                        
                        if Roll < 2 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.THREE_OF_SUNS,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 5 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.POCKET_8_BALL,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 15 then

                            SpawnCollectable(RFTSItems.MOONS_PEARL, POSITION)

                        elseif Roll < 25 then

                            SpawnCollectable(RFTSItems.ANGRY_SUN, POSITION)

                        elseif Roll < 50 then

                            SpawnCollectable(RFTSItems.MILKY_WAY_MILK, POSITION)

                        elseif Roll < 60 then

                            SpawnCollectable(RFTSItems.TINY_MIMAS, POSITION)

                        elseif Roll < 70 then

                            SpawnCollectable(RFTSItems.ALIEN_PEPPER, POSITION)

                        elseif Roll < 80 then

                            SpawnCollectable(RFTSItems.ERIS, POSITION)

                        elseif Roll < 100 then

                            SpawnCollectable(RFTSItems.URANIA, POSITION)

                        end

                    end  

                end

                if sprite:IsFinished("Payout") then ---Once the animation is done start the STATE PRIZE
                    
                    if SATURN_CHANCES.STATE_OF_PAYOUT < SATURN_CHANCES.MAX_PAYOUT then
        
                        SATURN_CHANCES.STATE_OF_PAYOUT = SATURN_CHANCES.STATE_OF_PAYOUT + 1

                    else

                        SATURN_CHANCES.STATE_OF_PAYOUT = 1

                    end

                    SATURN_CHANCES.STARS_RECIEVED = SATURN_CHANCES.STARS_RECIEVED - 3

                    Saturn.State = BeggarState.IDLE

                    Saturn.StateFrame = - 1

                end

                

            end

        end

    Saturn.StateFrame = Saturn.StateFrame + 1
    
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.SaturnOnUpdate, RFTSNpc.SATURN)
