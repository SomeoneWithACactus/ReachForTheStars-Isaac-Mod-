local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

local ALIEN_WORM = {
    KNOCKBACK = 16,
    KNOCKBACK_MULT = 2,
    FRICTION = 1.2,
    TEAR_LENGT = 100,
    TEAR_DMG_MULT = 0.15,
    TEAR_SIZE_MULT = 0.02,
    TEARRATE_MULT = 0.95,
    SHOT_SPEED = 2.5,
    DAMAGE_NOVA = 4.5,
}

---@param tear EntityTear
function mod:AlienWormTear(tear)

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(RFTSTrinkets.ALIEN_WORM) then

        if (tear.Position - player.Position):Length() > ALIEN_WORM.TEAR_LENGT then

            tear.CollisionDamage = tear.CollisionDamage + ALIEN_WORM.TEAR_DMG_MULT

            tear.Scale = tear.Scale + ALIEN_WORM.TEAR_SIZE_MULT
        
        end

        tear.Color = Color(
            0.0, ---Red
            0.8, ---Green
            0.8, ---Blue
            1.0,
            0.0, ---Red Offset
            0.5, ---Green Offset
            0.0  ----Blue Offset
            )

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.AlienWormTear)

---@param tear EntityTear
function mod:AlienWormFireTear(tear)

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(RFTSTrinkets.ALIEN_WORM) then

    local shootdirection = player:GetFireDirection()

    local dir1 = Vector(ALIEN_WORM.KNOCKBACK,0)
    local dir2 = Vector(0,ALIEN_WORM.KNOCKBACK)
    

    if shootdirection == Direction.LEFT then

        dir1 = Vector(ALIEN_WORM.KNOCKBACK,0)
        dir2 = Vector(0,0)
        
    elseif shootdirection == Direction.RIGHT then

        dir1 = Vector(0,0)
        dir2 = Vector(ALIEN_WORM.KNOCKBACK,0)
        
    elseif shootdirection == Direction.UP then

        dir1 = Vector(0,ALIEN_WORM.KNOCKBACK)
        dir2 = Vector(0,0)
        
    elseif shootdirection == Direction.DOWN then

        dir1 = Vector(0,0)
        dir2 = Vector(0,ALIEN_WORM.KNOCKBACK)
        
    end

        
        player.Velocity = (dir1 - dir2):Normalized() * 2 * ALIEN_WORM.KNOCKBACK_MULT

        SFX:Play(SoundEffect.SOUND_GFUEL_GUNSHOT_SMALL, 1, 2, false, 1.5)

        tear.Color = Color(
            0.0, ---Red
            0.8, ---Green
            0.8, ---Blue
            1.0,
            0.0, ---Red Offset
            0.5, ---Green Offset
            0.0  ----Blue Offset
            )

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.AlienWormFireTear)



---@param player EntityPlayer
function mod:AlienWormCache(player,flag)

    if player:HasTrinket(RFTSTrinkets.ALIEN_WORM) then

        if flag == CacheFlag.CACHE_DAMAGE then

            if player:GetPlayerType() ~= RFTSCharacters.NOVA then

            player.Damage = player.Damage - ALIEN_WORM.SHOT_SPEED

            player.Damage = player.Damage * player.ShotSpeed

            else

                player.Damage = player.Damage - ALIEN_WORM.DAMAGE_NOVA 
            
            end

        end

        if flag == CacheFlag.CACHE_FIREDELAY then
            
            player.MaxFireDelay = player.MaxFireDelay * ALIEN_WORM.TEARRATE_MULT

        end
        

        if flag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL 
        end

        if flag == CacheFlag.CACHE_SHOTSPEED then

            player.ShotSpeed = player.ShotSpeed + ALIEN_WORM.SHOT_SPEED

        end

    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.AlienWormCache)