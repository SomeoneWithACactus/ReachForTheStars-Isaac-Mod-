local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

---@param tear EntityTear
function mod:MoonPearlTear(tear)

    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(RFTSItems.MOONS_PEARL) then

        if tear.Variant == RFTSTears.MOON_PEARL then ---If the Tear IS the Star Tear
            
            tear.CollisionDamage = player.Damage * 1.5


            if (tear.Height >= -5 or tear:CollidesWithGrid()) then ---If the Tear is in the floor

                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, player.Position, Vector(0, 0), player)
        
                player.Position = tear.Position

                player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(player), 120)

                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, tear.Position, Vector(0, 0), player)

                SFX:Play(RFTSSounds.PEARL_TELEPORT)

                local roll = math.random(1,10)

                if roll <= 2 then

                    Isaac.Spawn(EntityType.ENTITY_CHARGER, 0, 0, player.Position, Vector.Zero, player):AddCharmed(EntityRef(player), -1)

                end

                tear:Remove()

            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.MoonPearlTear)