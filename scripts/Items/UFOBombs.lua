local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

local functions = {}

local UFOBOMB = {
    SPEED = 0.5,
    RANGE = 150,
}

local UFOBombSpriteBlacklist = {
    BombVariant.BOMB_TROLL,
    BombVariant.BOMB_THROWABLE,
    BombVariant.BOMB_GIGA,
    BombVariant.BOMB_ROCKET,
    BombVariant.BOMB_ROCKET_GIGA
}

local function onStart(_)
    PLAY_SOUND_TIMER = 1
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)


function functions.ValueInTable(table, value, returnKey) -- returns true if the value is contained in the table. returns false otherwise. returnKey is a boolean which when true returns what key the value was found in
    returnKey = returnKey or false
    local ValueIsInTable = nil
    for i = 1, #table do
        if table[i] == value then
            if returnKey then
                ValueIsInTable = i
            else
                ValueIsInTable = true
            end
            break
        end
        if i == #table then
            if returnKey then
                ValueIsInTable = nil
            else
                ValueIsInTable = false
            end
        end
    end
    return ValueIsInTable
end


function functions.getPlayerFromBomb(bomb) -- modified version of above function but also taken from james epic synergies mod
    if not bomb then return end
    if not bomb.SpawnerEntity then return end
    if bomb.SpawnerEntity:ToPlayer() then
        return bomb.SpawnerEntity:ToPlayer()
    end
end





---@param bomb EntityBomb
function mod:UFOBombsOnUpdate(bomb)

    if bomb.Variant == BombVariant.BOMB_THROWABLE then ---If the Bomb Variant is a Throwable Bomb, do not apply this code
        return
    end

    local player = functions.getPlayerFromBomb(bomb) ---Get Player from who place the bomb

    if not player then return end  ---If it did not place the bomb or if it does not have the UFO Bombs Items, do not apply this code
    if not player:HasCollectible(RFTSItems.UFO_BOMBS) then return end

    local rng = player:GetCollectibleRNG(RFTSItems.UFO_BOMBS) ---RNG for Dr Fetus

    if bomb.FrameCount == 1 then 

        if bomb.IsFetus then -- Make it so dr. fetus only spawns a holy bomb sometimes
        
            local UFOBombSpawnChance = 0.03 * (player.Luck + 11 / 3) -- Chance of it appearing with Dr Fetus

            if rng:RandomFloat() < UFOBombSpawnChance then

                bomb:GetData().drFetusUFOBomb = true

            end

        else

            bomb:GetData().regularUFOBomb = true

        end

    end

    if (bomb:GetData().drFetusUFOBomb or bomb:GetData().regularUFOBomb) and bomb:IsDead() == false then ---If the Bomb Is Still Charging
    
        if PLAY_SOUND_TIMER == 1 or PLAY_SOUND_TIMER == 2 then PLAY_SOUND_TIMER = 1 end ---Allow to Play the Timer Sound

        for _, entity in ipairs(Isaac.GetRoomEntities()) do ---Check for entitites
            
            if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then ---Check for enemies

                if (bomb.Position - entity.Position):Length() < UFOBOMB.RANGE then ---Is the Enemy in Range?
                
                    bomb.Velocity = (entity.Position - bomb.Position):Normalized() * UFOBOMB.SPEED * 8 ---Go for the Enemy

                end

            end

        end

    elseif (bomb:GetData().drFetusUFOBomb or bomb:GetData().regularUFOBomb) and bomb:IsDead() then ---If the Bomb Explode

        ----Spawn a Crack of the Sky Laser
        local SKYCRACK = Isaac.Spawn(EntityType.ENTITY_EFFECT,
        EffectVariant.CRACK_THE_SKY,
        0,
        bomb.Position,
        Vector.Zero,
        nil)

        SKYCRACK.Color = Color( ---Color of the SKYCRACK
            0.0, ---Red
            0.7, ---Green
            0.2, ---Blue
            1.0,
            0.0, ---Red Offset
            0.2, ---Green Offset
            0.2  ----Blue Offset
            )

        SKYCRACK.CollisionDamage = 3.5 ---Damage of the SKYCRACK

        ShootTears(RFTSTears.STAR_TEAR, bomb.Position, RFTSSounds.STAR_TEAR_SHOOT, 12, false, false, true, Color( ---Color of the SKYCRACK
        0.0, ---Red
        0.7, ---Green
        0.2, ---Blue
        1.0,
        0.0, ---Red Offset
        0.2, ---Green Offset
        0.2  ----Blue Offset
        ))

        PLAY_SOUND_TIMER = 2 ---Give the Chance again to Play the Timer Sound


    end

    if PLAY_SOUND_TIMER == 1 then ---Play Timer Sound

        SFX:Play(RFTSSounds.UFO_BOMBS_TIMER)

        PLAY_SOUND_TIMER = 0

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.UFOBombsOnUpdate)




---@param bomb EntityBomb
function mod:UFOBombsOnRender(bomb) ---On Rendering of the Bomb

    if functions.ValueInTable(UFOBombSpriteBlacklist, bomb.Variant) then return end ---DO NOT Applie this code to the Blacklisted list

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.UFO_BOMBS) and not player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE_BOMBS) then

            local sprite = bomb:GetSprite()

            ---Apply the Sprite of the UFO BOMBS
        
            if player:HasGoldenBomb() then ---Golden Bombs
        
                sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/ufo_gold.png")

                sprite:LoadGraphics()

            else ---Normal Bombs

                sprite:ReplaceSpritesheet(0, "gfx/items/pick ups/bombs/costumes/ufo.png")

                sprite:LoadGraphics()

            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_RENDER, mod.UFOBombsOnRender)