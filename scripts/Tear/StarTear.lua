local Game = Game()

---@param tear EntityTear
function Mod:StarTears(tear)

    local player = Isaac.GetPlayer(0)

        if tear.Variant == RFTSTears.STAR_TEAR then ---If the Tear IS the Star Tear

            local teardata = tear:GetData()

            if tear:GetSprite():IsFinished("Idle") then ---Once the Fading is Done

                tear:GetSprite():Play("Loop", true) ---Play the normal loop of the star

            end



            if (tear.Height >= -5 or tear:CollidesWithGrid()) and teardata.STARTEAR == nil then ---If the Tear is in the floor
            
                teardata.STARTEAR = Isaac.Spawn( ---Spawn the Star Creep
                EntityType.ENTITY_EFFECT,
                EffectVariant.PLAYER_CREEP_RED,
                0,
                tear.Position,
                Vector.Zero,
                player
                ):ToEffect()

                teardata.STARTEAR.Scale = tear.Scale - 0.1 ---Scale of the Star Creep


                teardata.STARTEAR.Color = tear.Color ---Color of the Star Creep


                teardata.STARTEAR.CollisionDamage = player.Damage * 0.80 ---Collision Damage of the Star Creep

            

                local starparticles = Isaac.Spawn( ---Particles on Collision of the Star Tear
                EntityType.ENTITY_EFFECT,
                EffectVariant.SCYTHE_BREAK,
                0,
                tear.Position,
                Vector.Zero,
                player
                ):ToEffect()

                starparticles.Color = tear.Color ---Color of the Particles


                ---CHECKERS OF HOW BIG THE TEAR IS WHEN FALLING AT THE FLOOR:

                if tear.Scale < 1.5 then ---Normal Size

                    SFX:Play(SoundEffect.SOUND_GLASS_BREAK) ---Play Glass Break Sound

                elseif tear.Scale >= 1.5 and tear.Scale < 2.2 then ---Big Size (Polyphemus Size)
                
                    SFX:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 2, false, 0.95) ---Play Rock Crumble Sound

                    Game:ShakeScreen(5) ---Shake the Screen

                elseif tear.Scale >= 2.2 then ---GIGANTIC SIZE (Idk how you can get this big tbh)

                    SFX:Play(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 2, false, 0.8) ---ECO OF SOUND WAVE

                    Game:ShakeScreen(15) ---Shake the Screen EVEN MORE

                    Isaac.Spawn( ---Creates a SHOCKWAVE (it can hurt the player)
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.SHOCKWAVE,
                    0,
                    tear.Position,
                    Vector.Zero,
                    player
                    ):ToEffect()

                end



            end

            local SMOKE_TEAR = Isaac.Spawn( ---Little Tear Creep Particles because it looks cool
                EntityType.ENTITY_EFFECT,
                EffectVariant.BLOOD_DROP,
                0,
                tear.Position,
                Vector.Zero,
                nil
                ):ToEffect()

            SMOKE_TEAR.Color = tear.Color ---Color of the Particles

end
    
end

Mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, Mod.StarTears)