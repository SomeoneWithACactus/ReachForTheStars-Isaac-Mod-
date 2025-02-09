local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local RNG_SHIFT_INDEX = 35


local function onStart(_)

    GasCounter = 0;

end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)


local DISNOMIA = {
    TEARRATE = 24,
    TEARSPEED = 10,
    DAMAGE = 3.5,
    GAS_TIME = 25
}

---@param player EntityPlayer
function mod:EvaluateCache(player)

    local effects = player:GetEffects()
    local count = effects:GetCollectibleEffectNum(RFTSItems.ERIS) + player:GetCollectibleNum(RFTSItems.ERIS)

    local rng = RNG()
    local seed = math.max(Random(), 1)

    rng:SetSeed(seed, RNG_SHIFT_INDEX)

    player:CheckFamiliar(RFTSFamiliars.DISNOMIA, count, rng, RFTSItemConfig.ERIS)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache, CacheFlag.CACHE_FAMILIARS)



---@param familiar EntityFamiliar
function mod:DisnomiaInit(familiar)

    familiar:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

    familiar.GridCollisionClass = EntityGridCollisionClass.GRIDCOLL_WALLS

    familiar:AddToFollowers()

    familiar.SpriteOffset = Vector(0, -15)
    
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.DisnomiaInit, RFTSFamiliars.DISNOMIA)



---@param familiar EntityFamiliar
function mod:DisnomiaOnUpdate(familiar)

    local sprite = familiar:GetSprite()

    local player = familiar.Player

    local firedirection = player:GetFireDirection()

    local direction = Vector(0,1)

    if firedirection == Direction.LEFT then

        direction = Vector(-1,0)
        
    elseif firedirection == Direction.RIGHT then

        direction = Vector(1,0)

    elseif firedirection == Direction.DOWN then

        direction = Vector(0,1)
        
    elseif firedirection == Direction.UP then

        direction = Vector(0,-1)
        
    end



  if sprite:IsPlaying("Gas") and sprite:GetFrame() == 3 then
        
        local WEIRD_GAS = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0, familiar.Position, Vector.Zero, player):ToEffect()


        if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then

            WEIRD_GAS.Scale = 2

        else

            WEIRD_GAS.Scale = 1.2

        end

        WEIRD_GAS.Color =  Color(
            0.8, ---Red
            0.0, ---Green
            0.5, ---Blue
            1.0,
            0.5, ---Red Offset
            0.0, ---Green Offset
            0.3  ----Blue Offset
            )

        WEIRD_GAS:Update()

        WEIRD_GAS.CollisionDamage = 0

        SFX:Play(SoundEffect.SOUND_SIREN_LUNGE)

    elseif sprite:IsPlaying("Shoot") and sprite:GetFrame() == 2 then

        if player:HasCollectible(CollectibleType.COLLECTIBLE_BFFS) then

            DISNOMIA.DAMAGE = 4.5

            DISNOMIA.GAS_TIME = 12;

        end
        
        ShootTearColor(direction,
        DISNOMIA.TEARSPEED,
        TearVariant.BLUE,
        familiar.Position,
        TearFlags.TEAR_SHRINK | TearFlags.TEAR_GODS_FLESH,
        false,
        Color(
            0.8, ---Red
            0.0, ---Green
            0.5, ---Blue
            1.0,
            0.5, ---Red Offset
            0.0, ---Green Offset
            0.3  ----Blue Offset
            ),
        DISNOMIA.DAMAGE)

        

    end

    if sprite:IsFinished("Shoot") or sprite:IsFinished("Gas") then
        
        sprite:Play("Idle", true)

    end

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == EffectVariant.SMOKE_CLOUD then

            for _, enemy in ipairs(Isaac.GetRoomEntities()) do

                if enemy:IsActiveEnemy() and enemy:IsVulnerableEnemy() then
            
                    if (entity.Position - enemy.Position):Length() < 64 then
                    
                        enemy:AddShrink(EntityRef(entity), 30)

                    end
                    

                end

            end

        end
        
    end



    if firedirection ~= Direction.NO_DIRECTION and familiar.FireCooldown == 0 and sprite:IsPlaying("Gas") == false then
    
            sprite:Play("Shoot")

            if GasCounter >= DISNOMIA.GAS_TIME then
                
                sprite:Play("Gas")

                GasCounter = 0

            else GasCounter = GasCounter + 1 end


        familiar.FireCooldown = DISNOMIA.TEARRATE

    end
    
    familiar:FollowParent()
    familiar.FireCooldown = math.max(familiar.FireCooldown - 1, 0)
    
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.DisnomiaOnUpdate, RFTSFamiliars.DISNOMIA)



---@param familiar EntityFamiliar
function mod:DisnomiaCreaturesRender(familiar)

    local sprite = familiar:GetSprite()

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.ERIS) then
        
            sprite:ReplaceSpritesheet(0, "gfx/familiars/familiar_creatures.png")

            sprite:ReplaceSpritesheet(1, "gfx/familiars/familiar_creatures.png")

            sprite:LoadGraphics()

        end

    end


end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.DisnomiaCreaturesRender, FamiliarVariant.MINISAAC)

---@param entity Entity
function mod:onKillEnemies(entity)

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.ERIS) then
        
            if entity:HasEntityFlags(EntityFlag.FLAG_SHRINK) and entity.Type ~= EntityType.ENTITY_GLOBIN then
                
                local roll = math.random(1,2)

                if roll == 1 then

                    for i = 1, math.random(1,3) do
                    
                    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.MINISAAC, 0, entity.Position, Vector.Zero, player)

                    end

                end

            end

        end

    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onKillEnemies)