local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local BLESSING_SPRITE = "gfx/005.300.01_blessing.anm2"

---@param player EntityPlayer
function mod:onPostUpdate(player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
            
            local data = entity:GetData()

            local sprite = entity:GetSprite()

            if entity.SubType == RFTSConsumables.BLESSING_FROM_THE_STARS then

                if sprite:GetFilename() ~= BLESSING_SPRITE and sprite:IsPlaying("Appear") then

                    sprite:Load(BLESSING_SPRITE, true)

                    sprite:Play("Appear")
                    
                elseif sprite:GetFilename() ~= BLESSING_SPRITE and sprite:IsPlaying("Idle") then

                    sprite:Load(BLESSING_SPRITE, true)

                    sprite:Play("Idle")

                end

            end

        end
        
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPostUpdate)



---@param player EntityPlayer
function mod:onCardUse(_, player)

    local level = game:GetLevel()

    
    ---CURSE OF THE BLIND >> BLESSING OF THE ENLIGHTED

    if level:GetCurses() == LevelCurse.CURSE_OF_BLIND then
        
        BlessingEffect("BLESSING OF THE ENLIGHTED", "Open your eyes to the stars!", LevelCurse.CURSE_OF_BLIND, BLESSINGS.BLESS_OF_THE_ENLIGHTED) 


    ---CURSE OF THE UNKNOWN >> BLESS OF THE KNOWLEGE

    elseif level:GetCurses() == LevelCurse.CURSE_OF_THE_UNKNOWN then
        
        BlessingEffect("BLESSING OF THE KNOWLEGE", "May you learn from your mistakes", LevelCurse.CURSE_OF_THE_UNKNOWN, BLESSINGS.BLESS_OF_THE_KNOWLEGE) 

    
    ---CURSE OF THE MAZE >> BLESS OF THE EXPLORER
    
    elseif level:GetCurses() == LevelCurse.CURSE_OF_MAZE then
        
        BlessingEffect("BLESSING OF THE EXPLORER", "Treasures and Wealth awaits in your way!", LevelCurse.CURSE_OF_MAZE, BLESSINGS.BLESS_OF_THE_EXPLORER) 


    ---CURSE OF THE LOST / CURSE OF DARKNESS >> BLESS OF THE SUN

    elseif level:GetCurses() == LevelCurse.CURSE_OF_THE_LOST  or level:GetCurses() == LevelCurse.CURSE_OF_DARKNESS then

        level:RemoveCurses(LevelCurse.CURSE_OF_DARKNESS)

        level:ShowMap()
        
        BlessingEffect("BLESSING OF THE SUN", "The bright light will make you shine!", LevelCurse.CURSE_OF_THE_LOST, BLESSINGS.BLESS_OF_THE_SUN) 


    ---IN CASE OF NO CURSE (OR CURSE OF THE LABYRINTH)

    else

        game:GetHUD():ShowItemText("GIFT FROM THE STARS", "No Curse to be undone, have this gift for your troubles!")

        SFX:Play(SoundEffect.SOUND_POWERUP1)

        if player:GetPlayerType() ~= RFTSCharacters.NOVA then ---Reward for other Characters

            ---Spawn Random Coin
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, player.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)

            ---Spawn Random Key
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, player.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)

            ---Spawn Random Bomb
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, player.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)

            ---Spawn Random Heart
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, player.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)

        else ---Reward for Nova

            for i = 1, 3 do
                
                Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                RFTSPickups.STARS,
                0, 
                player.Position,
                Vector((math.random(41)-21)/4,(math.random(41)-21)/4),
                nil)

                end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.onCardUse, RFTSConsumables.BLESSING_FROM_THE_STARS)