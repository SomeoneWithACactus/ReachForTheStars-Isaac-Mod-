local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

local function onStart(_)

    IsAuraActive = false

    InitializeStats = false

    TearCount = 0;

end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)

SPEAR = {
    SPEED = 10,
    TEAR = TearVariant.KEY,
    FLAG = TearFlags.TEAR_RIFT,
}

---@param player EntityPlayer
function mod:CelestialMaskOnUpdate(player)

    if player:HasCollectible(RFTSItems.CELESTIAL_MASK) then 

        if IsAuraActive == false then
            
            AURA = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWED_GROUND, 0, player.Position, Vector.Zero, player):ToEffect()

            IsAuraActive = true

        end

        if InitializeStats == false then

            player:AddTrinket(TrinketType.TRINKET_SUPER_MAGNET)

            player:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER, UseFlag.USE_NOANIM)

            InitializeStats = true

        end

        AURA.Parent = player

        AURA.Position = player.Position

        AURA.SpriteOffset = Vector(0, -10)

        AURA.Color = Color(
            0.0, ---Red
            1.0, ---Green
            0.2, ---Blue
            1.0,
            0.1, ---Red Offset
            0.5, ---Green Offset
            0.5  ----Blue Offset
            )

        local Radious = Isaac.FindInRadius(player.Position, 86, EntityPartition.ENEMY | EntityPartition.BULLET)

        for _, entity in ipairs(Radious) do

            if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
                    
                    entity:AddSlowing(EntityRef(player), 10, 0.5, Color(
                        0.0, ---Red
                        1.0, ---Green
                        0.2, ---Blue
                        1.0,
                        0.1, ---Red Offset
                        0.5, ---Green Offset
                        0.5  ----Blue Offset
                        ))
                        

            elseif entity.Type == EntityType.ENTITY_PROJECTILE then
                
                local projectile = entity:ToProjectile() 
                
                projectile.ProjectileFlags = ProjectileFlags.SLOWED

                projectile.Color = Color(
                    0.0, ---Red
                    1.0, ---Green
                    0.2, ---Blue
                    1.0,
                    0.1, ---Red Offset
                    0.5, ---Green Offset
                    0.5  ----Blue Offset
                    )

            end
            
        end


        

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.CelestialMaskOnUpdate)


function mod:CelestialOnShotTear(tear)

    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(RFTSItems.CELESTIAL_MASK) then 

        local firedirection = player:GetFireDirection()
        
        if TearCount >= 9 then

            if firedirection == Direction.RIGHT then
                    
                ShootTear(Vector(1,0), SPEAR.SPEED, SPEAR.TEAR, player.Position, SPEAR.FLAG)

            elseif firedirection == Direction.LEFT then
            
                ShootTear(Vector(-1,0), SPEAR.SPEED, SPEAR.TEAR, player.Position, SPEAR.FLAG)

            elseif firedirection == Direction.DOWN then
            
                ShootTear(Vector(0,1), SPEAR.SPEED, SPEAR.TEAR, player.Position, SPEAR.FLAG)

            elseif firedirection == Direction.UP then
            
                ShootTear(Vector(0,-1), SPEAR.SPEED, SPEAR.TEAR, player.Position, SPEAR.FLAG)

            end

            TearCount = 0

        else TearCount = TearCount + 1 end

    end

end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.CelestialOnShotTear)


function mod:PostNewRoomCelestial()
    
    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.CELESTIAL_MASK) then
            
            IsAuraActive = false

        end


    end

end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.PostNewRoomCelestial)



local CELESTIAL_DAMAGE = 1
local CELESTIAL_DAMAGE_MULT = 1.5
local CELESTIAL_RANGE = 50
local CELESTIAL_SPEED = 0.10

---@param player EntityPlayer
function mod:CelestialMaskOnCache(player, flag)

    if player:HasCollectible(RFTSItems.CELESTIAL_MASK) then

        
        if flag == CacheFlag.CACHE_DAMAGE then

            player.Damage = player.Damage + CELESTIAL_DAMAGE

            player.Damage = player.Damage * CELESTIAL_DAMAGE_MULT

        end

        if flag == CacheFlag.CACHE_RANGE then

            player.TearRange = player.TearRange + CELESTIAL_RANGE

        end

        if flag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_ORBIT_ADVANCED | TearFlags.TEAR_HOMING
        end

        if flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed - CELESTIAL_SPEED
        end

        if flag == CacheFlag.CACHE_TEARCOLOR then
            player.TearColor = Color(
                0.0, ---Red
                1.0, ---Green
                0.2, ---Blue
                1.0,
                0.1, ---Red Offset
                0.5, ---Green Offset
                0.5  ----Blue Offset
                )
        end


    end
    
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.CelestialMaskOnCache)


---@param entity Entity
function mod:onKillEnemies(entity)

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.CELESTIAL_MASK) then
        
            if (player.Position - entity.Position):Length() < 86 then
                
                local BaseAngle = 45 

                for Angle = BaseAngle, BaseAngle + 270, 90 do
                    
                    local CelestialLaser = EntityLaser.ShootAngle(LaserVariant.LIGHT_BEAM,
                    player.Position,
                    Angle,
                    10,
                    Vector.Zero,
                    player)

                    CelestialLaser.Color = Color(
                        0.0, ---Red
                        1.0, ---Green
                        0.2, ---Blue
                        1.0,
                        0.1, ---Red Offset
                        0.5, ---Green Offset
                        0.5  ----Blue Offset
                        )

                    CelestialLaser.CollisionDamage = player.Damage * 0.10

                end

            end

        end

    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onKillEnemies)



