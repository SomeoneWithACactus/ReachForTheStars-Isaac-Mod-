local mod = RegisterMod("Reach-for-the-Stars", 1)
local Game = Game()

ALIEN_PEPPER = {
    BASE_CHANCE = 1,
    MAX_LUCK = 7,
    SCALE = 0.8,
}

---@param tear EntityTear
function mod:StuffedTear(tear)

    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(RFTSItems.ALIEN_PEPPER) then ---If Player has ALIEN PEPPER

                if tear.Variant ~= RFTSTears.STUFFED_TEAR then

                    local roll = math.random(100)

                    if roll <= ((100 - ALIEN_PEPPER.BASE_CHANCE) * player.Luck / ALIEN_PEPPER.MAX_LUCK) + ALIEN_PEPPER.BASE_CHANCE then

                        local teardata = tear:GetData()

                        teardata.STUFFED_TEAR = math.random(1)

                        if teardata.STUFFED_TEAR == 1 and tear.Variant ~= TearVariant.FIRE then
                    
                            tear:ChangeVariant(RFTSTears.STUFFED_TEAR)

                            tear.Scale = tear.Scale - 0.10

                            tear.CollisionDamage = player.Damage * 2

                        else

                            teardata.STUFFED_TEAR = 0

                        end


                    end

                end

    end

end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.StuffedTear)


---@param tear EntityTear
function mod:TearOnUpdate(tear)

    if tear.Variant == RFTSTears.STUFFED_TEAR then

        local teardata = tear:GetData()
    
        if (tear.Height >= -5 or tear:CollidesWithGrid()) and tear.Variant == RFTSTears.STUFFED_TEAR then
                    
        local splash = Isaac.Spawn( ---Spawn Splash tear
            EntityType.ENTITY_EFFECT,
            EffectVariant.TEAR_POOF_B,
            0,
            tear.Position,
            Vector.Zero,
            player
            ):ToEffect()

            splash.Color = Color(
                1.0, ---Red
                0.7, ---Green
                0.0, ---Blue
                1.0,
                0.2, ---Red Offset
                0.0, ---Green Offset
                0.0  ----Blue Offset
                )


        end

        

        if tear:CollidesWithGrid() then

            local Grid = Game:GetRoom():GetGridEntityFromPos(tear.Position)

            if Grid:GetType() == GridEntityType.GRID_POOP or Grid:GetType() == GridEntityType.GRID_TNT then

                Grid:Hurt(1)

            end
                
        end

    end

end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.TearOnUpdate)

---@param Enemy Entity
---@param amount any
---@param flag any
---@param source any
function mod:StuffedTearsOnHit(Enemy, amount, flag, source)

    local player = Isaac.GetPlayer()

    if source.Type == EntityType.ENTITY_TEAR and source.Variant == RFTSTears.STUFFED_TEAR then

        SFX:Play(SoundEffect.SOUND_FIREDEATH_HISS)
                
        local splash = Isaac.Spawn( ---Spawn Splash tear
                    EntityType.ENTITY_EFFECT,
                    EffectVariant.TEAR_POOF_B,
                    0,
                    Enemy.Position,
                    Vector.Zero,
                    player
                    ):ToEffect()

        splash.Color = Color(
                    1.0, ---Red
                    0.7, ---Green
                    0.0, ---Blue
                    1.0,
                    0.2, ---Red Offset
                    0.0, ---Green Offset
                    0.0  ----Blue Offset
                    )       

        for g = 0, 360, 45 do
                      
                local fire = Isaac.Spawn( ---Spawn Fire
                            EntityType.ENTITY_TEAR,
                            TearVariant.FIRE,
                            0,
                            Isaac.GetFreeNearPosition(Enemy.Position, 5),
                            Vector.FromAngle(g) * Vector(5,5),
                            player
                            ):ToTear()

                fire.Color = Color(
                        0.0, ---Red
                        0.7, ---Green
                        0.2, ---Blue
                        1.0,
                        0.0, ---Red Offset
                        0.2, ---Green Offset
                        0.2  ----Blue Offset
                        )

                fire.CollisionDamage = player.Damage * 1.5

                fire.Scale = 1.5

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.StuffedTearsOnHit)