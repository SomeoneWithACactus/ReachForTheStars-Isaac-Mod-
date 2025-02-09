local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local Curstage
local RoomConfig

local Register

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



function RemoveFromRegister(Saturn)

    for i = 1, #Register do

        if Register[i].Room == game:GetLevel():GetCurrentRoomIndex()
        and Register[i].Position.X == Saturn.Position.X
        and Register[i].Position.Y == Saturn.Position.Y 
        and Register[i].Entity.Type == Saturn.Type
        and Register[i].Entity.Variant == Saturn.Variant
        then
            
            table.remove(Register, i)

            break

        end
         
    end
    
end



function SpawnRegister()

    local player = Isaac.GetPlayer()

    for i = 1, #Register do

        if Register[i].Room == game:GetLevel():GetCurrentRoomIndex() then
            
            local Saturn = Isaac.Spawn(
                RFTSNpc.SATURN,
                0,
                0,
                Vector(320,280),
                Vector.Zero,
                nil
            )

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

            if Register[i].Entity.Type == RFTSNpc.SATURN then
                
                local beggarFlag = EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS

                Saturn:ClearEntityFlags(Saturn:GetEntityFlags())

                Saturn:AddEntityFlags(beggarFlag)

                Saturn.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

            end

        end
        
    end
    
end


function SaveStateBeggar() ---Save Beggar's Position

    local SaveData = ""

    for i = 1, #Register do
        
        SaveData = SaveData
            .. string.format("%5u",Register[i].Room)
            .. string.format("%4u",Register[i].Position.X)
            .. string.format("%4u",Register[i].Position.Y)
            .. string.format("%4u",Register[i].Entity.Type)
            .. string.format("%4u",Register[i].Entity.Variant)

    end

    mod:SaveData(SaveData)
    
end


function mod:onStarted(fromSave)

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if fromSave then
            local ModData = Mod:LoadData()

            Register = {}

            for j = 5, ModData:len(), 21 do
                
                table.insert(Register,
            {
                Room = tonumber(ModData:sub(j, j + 4)),
                Position = Vector(320,280),
                Entity = {
                    Type = tonumber(ModData:sub(j+13,j+16)),
                    Variant = tonumber(ModData:sub(j+17,j+20))
                }
            }
            )

            end

            SpawnRegister()

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onStarted)


function mod:onRoom()

    local NewRoom = true

    RoomConfig = {}
    local room = game:GetRoom()

    for i = 1, room:GetGridSize() do
        
        local Grid = room:GetGridEntity(i)

        if Grid == nil then

            RoomConfig[i] = nil

        else

            RoomConfig[i] = {Type = Grid.Desc.Type,
            Variant = Grid.Desc.Variant,
            State = Grid.Desc.State}

        end

    end

    if game:GetFrameCount() <= 1 then
        Register = {}
    end

    local level = game:GetLevel()

    if Curstage ~= level:GetStage() then
        
        Register = {}

    end

    Curstage = level:GetStage()

    SpawnRegister()

    local starting = game:GetLevel():GetStartingRoomIndex()

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type ~= RFTSNpc.SATURN and game:GetLevel():GetCurrentRoomIndex() == game:GetLevel():GetStartingRoomIndex() and NewRoom == true then

                local Saturn = Isaac.Spawn(
                    RFTSNpc.SATURN,
                    0,
                    0,
                    Vector(320,280),
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

        end
        
    end

end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onRoom)

function mod:onExit(shouldSave)
    
    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:GetPlayerType() ~= RFTSCharacters.NOVA then
            return
        end

    SaveStateBeggar() ---Save Beggar Position

    SaveStateStars() ---Save Stars Amount

    end
    
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.onExit)

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
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)



---INITIATION OF BEGGAR
function mod:BeggarInit(entity)

    ---Do this so it will not die from other dudes
    entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.BeggarInit, RFTSNpc.SATURN)


function mod:OnUpdateNova(...)

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        
        if player:GetPlayerType() ~= RFTSCharacters.NOVA then
            return
        end

        local room = game:GetRoom()

        if room:GetType() == RoomType.ROOM_BOSS and room:IsFirstVisit() then
        
            ACTIVATE_PORTAL.BOSS = true

        end

        if room:GetType() == RoomType.ROOM_TREASURE and room:IsFirstVisit() then
        
            ACTIVATE_PORTAL.TREASURE = true

        end
    
    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, Mod.OnUpdateNova)



-------FUNCTION TO SPAWN A COLLECTABLE WITHOUT MAKING A SHITTON OF CODE-------

function SpawnCollectable(collectable, position) ---Spawn a Collectable

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(collectable) == false then

            Isaac.Spawn(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectable,
            position,
            Vector(0, 0),
            player)

        else

            Isaac.Spawn(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            RFTSItems.EXPLORER_BREAKFAST,
            position,
            Vector(0, 0),
            player)

        end

    end
    
end


function mod:SaturnOnUpdate(Saturn)

    local Saturn = Saturn:ToNPC()

    local beggarFlag = EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS

    if Saturn:GetEntityFlags() ~= beggarFlag then

        Saturn:ClearEntityFlags(Saturn:GetEntityFlags())

        Saturn:AddEntityFlags(beggarFlag)

        Saturn.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

        local roomIndex = game:GetLevel():GetCurrentRoomIndex()

        table.insert(Register, {
            Room = roomIndex,
            Position = Saturn.Position,
            Entity = {Type = Saturn.Type, Variant = Saturn.Variant},
        })

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
                            Card.CARD_STARS,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 100 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.BLESSING_FROM_THE_STARS,
                            POSITION,
                            Vector(0, 0),
                            player)

                        end

                    elseif SATURN_CHANCES.STATE_OF_PAYOUT == 3 then

                        local Roll = Saturn:GetDropRNG():RandomInt(100) ---Roll a Dice: What will it be your 
                        
                        if Roll < 25 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.POCKET_8_BALL,
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

                        local Roll = Saturn:GetDropRNG():RandomInt(100) ---Roll a Dice: What will it be your 
                        
                        if Roll < 5 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.THREE_OF_SUNS,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 15 then
                            
                            Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.POCKET_8_BALL,
                            POSITION,
                            Vector(0, 0),
                            player)

                        elseif Roll < 25 then

                            SpawnCollectable(RFTSItems.MILKY_WAY_MILK, POSITION)

                        elseif Roll < 50 then

                            SpawnCollectable(RFTSItems.ANGRY_SUN, POSITION)

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

mod:onRoom()