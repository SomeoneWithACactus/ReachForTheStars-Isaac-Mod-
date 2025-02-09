local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

---@param tear EntityTear
function mod:AlienWormTear(tear)

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(RFTSTrinkets.LAZY_ALIEN_WORM) then

        tear.Friction = 0.8

        if (tear.Height >= -5 or tear:CollidesWithGrid()) and tear.Scale >= 1.8 then
            
            if player:HasCollectible(RFTSItems.URANIA) then
                
                ShootTears(RFTSTears.STAR_TEAR, tear.Position, SoundEffect.SOUND_EXPLOSION_WEAK, 10, false,true,true,Color(
                    0.0, ---Red
                    0.8, ---Green
                    0.8, ---Blue
                    1.0,
                    0.0, ---Red Offset
                    0.5, ---Green Offset
                    0.0  ----Blue Offset
                    ))
        
                    tear:Remove()
                
            else

                ShootTears(TearVariant.BLUE, tear.Position, SoundEffect.SOUND_EXPLOSION_WEAK, 10, false,true,true,Color(
                .0, ---Red
                0.8, ---Green
                0.8, ---Blue
                1.0,
                0.0, ---Red Offset
                0.5, ---Green Offset
                0.0  ----Blue Offset
                ))

                tear:Remove()

            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.AlienWormTear)

---@param tear EntityTear
function mod:AlienWormFireTear(tear)

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(RFTSTrinkets.LAZY_ALIEN_WORM) then

        if player:HasCollectible(RFTSItems.URANIA) then

            tear.Scale = tear.Scale * 1.5

            tear.Color = Color(
            0.0, ---Red
            0.8, ---Green
            0.8, ---Blue
            1.0,
            0.0, ---Red Offset
            0.5, ---Green Offset
            0.0  ----Blue Offset
            )

        else

            tear.Scale = tear.Scale * 2

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
    
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.AlienWormFireTear)
