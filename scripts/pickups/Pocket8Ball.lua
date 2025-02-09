local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local BALL_SPRITE = "gfx/005.300.02_pocket8ball.anm2"

---@param player EntityPlayer
function mod:onPostUpdate(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
            
            local data = entity:GetData()

            local sprite = entity:GetSprite()

            if entity.SubType == RFTSConsumables.POCKET_8_BALL then

                if sprite:GetFilename() ~= BALL_SPRITE and sprite:IsPlaying("Appear") then

                    sprite:Load(BALL_SPRITE, true)

                    sprite:Play("Appear")

                    sprite.Offset = Vector(0,5)
                    
                elseif sprite:GetFilename() ~= BALL_SPRITE and sprite:IsPlaying("Idle") then

                    sprite:Load(BALL_SPRITE, true)

                    sprite:Play("Idle")

                    sprite.Offset = Vector(0,5)

                end

            end

        end
        
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPostUpdate)

function Pocket8BallFortune(str, str2)

    local Hud = game:GetHUD()

    Hud:ShowFortuneText(str,str2)

    SFX:Play(SoundEffect.SOUND_POWERUP_SPEWER)
    
end


---@param player EntityPlayer
function mod:Pocket8BallOnUse(_, player)

    local roll = math.random(100)

    local level = game:GetLevel()

    local seed = game:GetSeeds():GetStartSeed()

    local POSITION_PLAYER = Isaac.GetFreeNearPosition(player.Position, 50)

    if roll < 25 then

        player:AddSoulHearts(4)

        Pocket8BallFortune("Strength","your Soul!")
        
    elseif roll < 50 then

        Pocket8BallFortune("The Stars"," are Calling!")

        for _, entity in ipairs(Isaac.GetRoomEntities()) do

            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then

                Isaac.Spawn(EntityType.ENTITY_EFFECT, 
                EffectVariant.POOF01, 
                0,
                entity.Position,
                Vector.Zero,
                nil)

                Isaac.Spawn(EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                game:GetItemPool():GetCollectible(ItemPoolType.POOL_PLANETARIUM, true, seed),
                entity.Position,
                Vector.Zero,
                nil)
                
                entity:Remove()
    
            end
                
        end
            
    elseif roll < 75 then

        Pocket8BallFortune("Pocket in your", "Pockets!")

        Isaac.Spawn(EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_TRINKET,
                0,
                POSITION_PLAYER,
                Vector.Zero,
                nil)

    elseif roll <= 100 then

        Pocket8BallFortune("Ask Again", "Later!")

    end
    
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.Pocket8BallOnUse, RFTSConsumables.POCKET_8_BALL)