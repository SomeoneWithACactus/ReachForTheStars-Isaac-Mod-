local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local level = game:GetLevel()
local room = game:GetRoom()

local NewRoom = true

local function onStart(_)

    NewRoom = true

end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)


---INITIATION OF BEGGAR
---@param entity EntityNPC
function mod:BeggarInit(entity)

    local sprite = entity:GetSprite()

    ---Do this so it will not die from other dudes
    entity:AddEntityFlags(EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_STATUS_EFFECTS)
    entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY

    sprite:Play("Appear")

end

mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.BeggarInit, RFTSNpc.LITTLE_SHIP)




---@param entity EntityNPC
function mod:LittleShipUpdate(entity)

    local sprite = entity:GetSprite()

    local data = entity:GetData()

    if data.Position == nil then data.Position = entity.Position end
    entity.Velocity = data.Position - entity.Position

    if sprite:IsFinished("Appear") then
        
        sprite:Play("Idle")

    end
    
end

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.LittleShipUpdate, RFTSNpc.LITTLE_SHIP)



---@param player EntityPlayer
function mod:LittleShipAppear(player)

    if player:GetPlayerType() ~= RFTSCharacters.NOVA then
       
        if game:GetFrameCount() <= 1800 then

            if room:GetType() == RoomType.ROOM_BOSS and room:IsClear() and NewRoom == true then

                local UFO_BEAM = Isaac.Spawn(EntityType.ENTITY_EFFECT, RFTSEffects.LIGHT_UFO, 0, room:GetCenterPos(), Vector.Zero, player):ToEffect()

                UFO_BEAM.Color = Color( ---Color of the SKYCRACK
                         0.0, ---Red
                         0.7, ---Green
                         0.2, ---Blue
                         1.0,
                         0.0, ---Red Offset
                         0.2, ---Green Offset
                         0.2  ----Blue Offset
                         )

                SFX:Play(RFTSSounds.LITTLE_SHIP_APPEARS, 0.8)

                game:Darken(1,60)

                Isaac.Spawn(RFTSNpc.LITTLE_SHIP, 0, 0, room:GetCenterPos(), Vector.Zero, nil)

                NewRoom = false
           
            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.LittleShipAppear)



---this will make it so it will not die from you :P
---@param target EntityNPC
function mod:BeggarDamage(target, dmg, flag, source, countdown)

    if flag & DamageFlag.DAMAGE_EXPLOSION > 0 then

       SpawnCollectable(RFTSItems.NOVAS_CONTROLER, target.Position)

       local LASER_BEAM = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0, target.Position, Vector.Zero, player):ToEffect()

       LASER_BEAM.Color = Color( ---Color of the SKYCRACK
                0.0, ---Red
                0.7, ---Green
                0.2, ---Blue
                1.0,
                0.0, ---Red Offset
                0.2, ---Green Offset
                0.2  ----Blue Offset
                )

        for i = 1, 3 do
                
            Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            RFTSPickups.STARS,
            0, 
            target.Position,
            Vector((math.random(41)-21)/4,(math.random(41)-21)/4),
            nil)
    
        end

        SFX:Play(SoundEffect.SOUND_ANIMA_BREAK)

        return 1

    else

        return false

    end


end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.BeggarDamage, RFTSNpc.LITTLE_SHIP)