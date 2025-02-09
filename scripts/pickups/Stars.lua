local Game = Game()

UILayout = {
    STAR_ICON = Vector(48, 44),
    STAR_NUMBER = Vector(64, 48),
    STAR_FRAME = 13
}

function SaveStateStars() ---Save the amount of stars

    for i = 0, Game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)
        local SaveData = ""

        if player:GetData().Stars < 10 then
            SaveData = SaveData .. "0"
        end
    
        SaveData = SaveData .. player:GetData().Stars

        Mod:SaveData(SaveData)

    end

end

function Mod:PostNewFloorSave() 

    for i = 0, Game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:GetPlayerType() ~= RFTSCharacters.NOVA then
            return
        end

        if Game:GetLevel():GetStage() ~= LevelStage.STAGE1_1 then

            SaveStateStars() ---Save the amount of stars

        end

    end
    
end

Mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, Mod.PostNewFloorSave)


---@param player EntityPlayer
function Mod:StarsOnUpdate(player)

    if player:GetPlayerType() == RFTSCharacters.NOVA then

        if Game:GetFrameCount() == 1 then ---Set Stars on the Beggining of a New Run
        
            player:GetData().Stars = 0
    
        elseif player.FrameCount == 1 and Mod:HasData() then ---Set Stars on Continuing a Run
    
            local ModDataStars = Mod:LoadData()
    
            player:GetData().Stars = tonumber(ModDataStars:sub(1,2))
    
        end

    end


    


    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP ---Check if the Entity is a Pickup
        and (player.Position - entity.Position):Length() < player.Size + entity.Size then ---Check if player is touching the pickup
            
            if entity.Variant == RFTSPickups.STARS ---Check if it is the Stars
            and entity:GetSprite():IsPlaying("Idle") ---Check if it stopped appearing
            and entity:GetData().Picked == nil then ---Check if it has been picked up
                
                ---It has been picked up
                entity:GetData().Picked = true

                ---Stop collisions so it will not fly around
                entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

                ---Play the collect sprite
                entity:GetSprite():Play("Collect", true)

            
                if player:GetPlayerType() == RFTSCharacters.NOVA then

                    ---Play sound effect on pick up
                    SFX:Play(RFTSSounds.STAR_PICKUP)

                    ---Add a Star
                    player:GetData().Stars = math.min(99, player:GetData().Stars + 1)

                    SaveStateStars() ---Save the amount of stars

                else

                    ---Play sound effect on pick up
                    SFX:Play(SoundEffect.SOUND_ANIMA_BREAK)
                
                    ---Spawn Random Coin
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, player.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)

                    ---Spawn Random Key
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0, player.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)

                    ---Spawn Random Bomb
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0, player.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)

                    ---Spawn Random Heart
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0, player.Position, Vector((math.random(41)-21)/4,(math.random(41)-21)/4), nil)


                end

            end

        end

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == RFTSPickups.STARS ---Check if it is the Stars
        and entity:GetSprite():IsEventTriggered("DropSound") then ---Check if the Drop Sound event is triggering
                
                SFX:Play(RFTSSounds.STAR_APPEAR) ---Play Sound

        end

        ---Delete Star once Collected
        if entity.Type == EntityType.ENTITY_PICKUP ---Check if the entity is a Pickup
        and entity:GetData().Picked == true ---Check if it has been picked up
        and entity:GetSprite():GetFrame() == 6 then ---Check if the collect animation is done

            entity:Remove() ---Remove Pickup

        end

    end

end

Mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Mod.StarsOnUpdate)


-----Define Star Icon
local HudPickups = Sprite()
HudPickups:Load("gfx/ui/hudpickups.anm2", true)

-----Define Number
local HudNumbers = Sprite()
HudNumbers:Load("gfx/ui/hudnumbers.anm2", true)


----Rendering Number Function Call
function RenderNumberStar(n, position)
    if n == nil then n = 0 end

    HudNumbers:SetFrame("Idle", math.floor(n/10))
    HudNumbers:RenderLayer(0,position)
    HudNumbers:SetFrame("Idle", n % 10)
    HudNumbers:RenderLayer(0,position + Vector(6,0))

end

----Rendering the Icons and Numbers
function Mod:onRenderStar()

    for i = 0, Game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:GetPlayerType() ~= RFTSCharacters.NOVA then
            return
        end

        HudPickups:SetFrame("Idle", UILayout.STAR_FRAME)
        HudPickups:RenderLayer(0, UILayout.STAR_ICON)

        RenderNumberStar(player:GetData().Stars, UILayout.STAR_NUMBER)

    end
    
end

Mod:AddCallback(ModCallbacks.MC_POST_RENDER, Mod.onRenderStar)