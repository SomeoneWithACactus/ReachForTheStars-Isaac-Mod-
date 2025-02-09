local Game = Game()
local mod = RegisterMod("Reach-for-the-Stars", 1)


---@param tear EntityTear
function Mod:UraniaTears(tear)

    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(RFTSItems.URANIA) then ---If Player has URANIA
        
        if tear.Variant ~= RFTSTears.STAR_TEAR then ---If the Variant isn't the Star Tear

            tear:ChangeVariant(RFTSTears.STAR_TEAR) ---Make it the the Star Tear

            tear.Scale = tear.Scale + 0.05 ---Make it smaller

            tear.CollisionDamage = player.Damage ---Damage of the Tear

                        ----SOUND EFFECT OF THE STAR FALLING---

            local pitch = math.random() + 0.7 ---Pitch of the sound effect

            SFX:Play(RFTSSounds.STAR_TEAR_SHOOT, 1, 2, false, pitch) ---Play Sound Effect

        end



        local FireDirectionDude = player:GetFireDirection() ---FireDirection of the Player

        ------------TRYING A SYNERGY WITH BRIMSTONE----------

        if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) and FireDirectionDude ~= Direction.NO_DIRECTION then

            if Game:GetFrameCount() % 25 == 0 then ---Time it takes to fire
            
            local STARSBRIMSTONE = Isaac.Spawn( ---Spawn a Star Tear
                        EntityType.ENTITY_TEAR,
                        RFTSTears.STAR_TEAR,
                        0,
                        player.Position,
                        Vector((math.random(80)-21)/4,(math.random(80)-21)/4),
                        player
                        ):ToTear()

            STARSBRIMSTONE.Color = player.LaserColor ---Star Tear Color
            STARSBRIMSTONE.TearFlags = player.TearFlags ---Inherent Tear Flags

            local pitch = math.random() + 0.7

            SFX:Play(RFTSSounds.STAR_TEAR_SHOOT, 1, 2, false, pitch)

            end

        end

    end

end

Mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Mod.UraniaTears)

local URANIA_TEARS = 4
local URANIA_DAMAGE_MULT = 1.8
local URANIA_DAMAGE = 1
local URANIA_SHOTSPEED = 0.10

---@param player EntityPlayer
function Mod:UraniaOnCache(player, flag)

    if player:HasCollectible(RFTSItems.URANIA) then

        
        if flag == CacheFlag.CACHE_DAMAGE then

            player.Damage = player.Damage * URANIA_DAMAGE_MULT

            player.Damage = player.Damage + URANIA_DAMAGE

        end

        if flag == CacheFlag.CACHE_SHOTSPEED then

            player.ShotSpeed = player.ShotSpeed + URANIA_SHOTSPEED

        end

        if flag == CacheFlag.CACHE_RANGE then

            player.TearFallingSpeed = player.TearFallingSpeed + 10

            player.TearFallingAcceleration = player.TearFallingAcceleration + 1

        end

        if flag == CacheFlag.CACHE_FIREDELAY then
            
            player.MaxFireDelay = player.MaxFireDelay * URANIA_TEARS

        end
        

        if flag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_PIERCING | TearFlags.TEAR_SPECTRAL
        end

        if flag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = Color(
                1.0, ---Red
                1.0, ---Green
                0.2, ---Blue
                1.0,
                0.5, ---Red Offset
                0.0, ---Green Offset
                0.5  ----Blue Offset
                )
        end


    end
    
end

Mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Mod.UraniaOnCache)



------------ON HIT EFFECT--------------



function Mod:UraniaTearsOnHit(Enemy, amount, flag, source)

    local player = Isaac.GetPlayer()

    if source.Type == EntityType.ENTITY_TEAR and player:HasCollectible(RFTSItems.URANIA) then

        for _, entity in ipairs(Isaac.GetRoomEntities()) do

            if (source.Position - entity.Position):Length() < 2 + entity.Size  then ---Check if you has collide with the Enemy
                
                local CREEPTEAR = Isaac.Spawn( ---Spawn Star Creep
                            EntityType.ENTITY_EFFECT,
                            EffectVariant.BLOOD_EXPLOSION,
                            0,
                            entity.Position,
                            Vector.Zero,
                            nil
                            ):ToEffect()

                CREEPTEAR.Scale = 0.2 ---Scale of creep

                CREEPTEAR.Color = player.TearColor ---Color of Creep

            end

            if entity.Type == EntityType.ENTITY_TEAR then

                local tear = entity:ToTear()

                tear.SpriteScale = tear.SpriteScale - Vector(-0.05,-0.05)
                tear.CollisionDamage = tear.CollisionDamage + 0.50

            end
        end

    end
    
end

Mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Mod.UraniaTearsOnHit)