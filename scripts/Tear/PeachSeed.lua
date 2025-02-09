local Game = Game()

---@param tear EntityTear
function Mod:PeachSeed(tear)

    local player = Isaac.GetPlayer(0)

    if tear.Variant == RFTSTears.PEACH_SEED then ---If the Tear IS the Star Tear
            
        tear.CollisionDamage = player.Damage * 1.5


        if (tear.Height >= -5 or tear:CollidesWithGrid()) then ---If the Tear is in the floor
        

            local POOF = Isaac.Spawn( ---Particles on Collision of the Star Tear
                EntityType.ENTITY_EFFECT,
                EffectVariant.TEAR_POOF_A,
                0,
                tear.Position,
                Vector.Zero,
                player
                ):ToEffect()

                POOF.Color = Color(
                    1.5, ---Red
                    0.7, ---Green
                    0.0, ---Blue
                    1.0,
                    0.0, ---Red Offset
                    0.0, ---Green Offset
                    0.0  ----Blue Offset
                    )

        end

    end
    
end

Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, Mod.PeachSeed)