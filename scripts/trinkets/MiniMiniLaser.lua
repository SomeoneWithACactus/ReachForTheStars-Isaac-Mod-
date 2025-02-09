local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

MINILASER = {

    BASE_CHANCE = 1,
    MAX_LUCK = 10,

}

function ShootLaser(LASER, COLOR, FLAG)
    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)
    
        local DirectionShoot = player:GetFireDirection()

        local Angle = 0

        if DirectionShoot == Direction.UP then
            
            Angle = 270

        elseif DirectionShoot == Direction.DOWN then
            
            Angle = 90

        elseif DirectionShoot == Direction.LEFT then
            
            Angle = 180

        elseif DirectionShoot == Direction.UP then
            
            Angle = 360

        end

        local LASERTOSHOOT = EntityLaser.ShootAngle(LASER, player.Position, Angle, 5, Vector(0,-10), player)

        LASERTOSHOOT.Color = COLOR

        LASERTOSHOOT.TearFlags = FLAG

        LASERTOSHOOT.CollisionDamage = 1.5

    end

end

function mod:MiniLaserOnUpdate()
    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasTrinket(RFTSTrinkets.MINI_MINILASER) then
            
            local roll = math.random(100)

                if roll <= ((100 - MINILASER.BASE_CHANCE) * player.Luck / MINILASER.MAX_LUCK) + MINILASER.BASE_CHANCE then
                        
                    ShootLaser(LaserVariant.THIN_RED, 
                        Color(
                        0.0, ---Red
                        0.2, ---Green
                        0.8, ---Blue
                        1.0,
                        0.0, ---Red Offset
                        0.0, ---Green Offset
                        0.2  ----Blue Offset
                        ),
                        TearFlags.TEAR_GODS_FLESH)

            end          

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.MiniLaserOnUpdate)