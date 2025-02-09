local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

local RedContrast = 2;

local function onStart(_)

    IsEffectActive = false

    ANGLE = 0

    ANGLE2 = 180

    RedContrast = 2;

end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)



function mod:GetShaderParams(RedShader)
    local params = { 
            Conditional = { RedContrast }
            }
    return params;
end
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, mod.GetShaderParams)




---@param player EntityPlayer
function mod:VirtualKidOnUse(_,_,player)

    IsEffectActive = true

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
            
            entity:AddEntityFlags(EntityFlag.FLAG_WEAKNESS)

            entity.Color = Color(
                0.8, ---Red
                0.0, ---Green
                0.2, ---Blue
                1.0,
                0.5, ---Red Offset
                0.0, ---Green Offset
                0.1  ----Blue Offset
                )

        end
         
    end

    game:ShakeScreen(5)

    SFX:Play(SoundEffect.SOUND_LASERRING_STRONG)
    
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.VirtualKidOnUse, RFTSItems.VIRTUAL_KID)

---@param player EntityPlayer
function mod:VirtualKidUpdate(player)

    if player:HasCollectible(RFTSItems.VIRTUAL_KID) then
        
        if IsEffectActive == true then

            if RedContrast ~= 0.5 then RedContrast = 0.5 end
            
            ANGLE = ANGLE + 1

            ANGLE2 = ANGLE2 - 1

            if game:GetFrameCount() % 5 == 0 then

                local VIRTUAL_LASERS = {

                LASER_1 = EntityLaser.ShootAngle(LaserVariant.THIN_RED, player.Position, ANGLE, 5, Vector.Zero, player),

                LASER_2 = EntityLaser.ShootAngle(LaserVariant.THIN_RED, player.Position, ANGLE * -1, 5, Vector.Zero, player),

                LASER_3 = EntityLaser.ShootAngle(LaserVariant.THIN_RED, player.Position, ANGLE2, 5, Vector.Zero, player),

                LASER_4 = EntityLaser.ShootAngle(LaserVariant.THIN_RED, player.Position, ANGLE2 * -1, 5, Vector.Zero, player),

                }


                VIRTUAL_LASERS.LASER_1.CollisionDamage = 1.5 * player.Damage 

                VIRTUAL_LASERS.LASER_2.CollisionDamage = 1.5 * player.Damage 

                VIRTUAL_LASERS.LASER_3.CollisionDamage = 1.5 * player.Damage 

                VIRTUAL_LASERS.LASER_4.CollisionDamage = 1.5 * player.Damage 

                local TEAR = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLOOD, 0, player.Position, Vector(math.random(-10,10), math.random(-10,10)), player):ToTear()

                TEAR.Color = Color(
                    0.8, ---Red
                    0.0, ---Green
                    0.2, ---Blue
                    1.0,
                    0.5, ---Red Offset
                    0.0, ---Green Offset
                    0.1  ----Blue Offset
                    )

                TEAR.CollisionDamage = player.Damage

                TEAR.FallingSpeed = -4

                TEAR.FallingAcceleration = 1
                
            end

            if game:GetFrameCount() % 450 == 0 then

                if player:GetHearts() + player:GetSoulHearts() + player:GetBoneHearts() + player:GetRottenHearts() > 1 then

                player:TakeDamage(1, DamageFlag.DAMAGE_RED_HEARTS | DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_NO_MODIFIERS, EntityRef(player), 120)

                if player:GetPlayerType() ~= RFTSCharacters.NOVA then

                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player)

                else

                    local NOVABLOOD = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, player.Position, Vector.Zero, player):ToEffect()

                    NOVABLOOD.Color = Color(
                        0.8, ---Red
                        0.0, ---Green
                        0.5, ---Blue
                        1.0,
                        0.5, ---Red Offset
                        0.0, ---Green Offset
                        0.3  ----Blue Offset
                        )

                end

                end

            end

            

            player.FireDelay = player.MaxFireDelay


        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.VirtualKidUpdate)


function mod:VirtualKidOnNewRoom()

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.VIRTUAL_KID) then
        
            if IsEffectActive == true then

                IsEffectActive = false

                player.FireDelay = player.FireDelay

                if RedContrast ~= 2 then RedContrast = 2 end
                
            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.VirtualKidOnNewRoom)