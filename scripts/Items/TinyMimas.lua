local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

local RNG_SHIFT_INDEX = 35

---@param player EntityPlayer
function mod:EvaluateCache(player)

    local effects = player:GetEffects()
    local count = effects:GetCollectibleEffectNum(RFTSItems.TINY_MIMAS) + player:GetCollectibleNum(RFTSItems.TINY_MIMAS)

    local rng = RNG()
    local seed = math.max(Random(), 1)

    rng:SetSeed(seed, RNG_SHIFT_INDEX)

    player:CheckFamiliar(RFTSFamiliars.TINY_MIMAS, count, rng, RFTSItemConfig.TINY_MIMAS)
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache, CacheFlag.CACHE_FAMILIARS)

---@param Mimas EntityFamiliar
function mod:MimasInit(Mimas)

    Mimas:AddToOrbit(7007)
    
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.MimasInit, RFTSFamiliars.TINY_MIMAS)



---@param Mimas EntityFamiliar
function mod:MimasUpdate(Mimas)

    if Mimas.Variant ~= RFTSFamiliars.TINY_MIMAS then return end

    local sprite = Mimas:GetSprite()

    local player = Mimas.Player


        Mimas.OrbitDistance = Vector(48,48)

        Mimas.OrbitSpeed = 0.02

        Mimas.Velocity = Mimas:GetOrbitPosition(player.Position + player.Velocity) - Mimas.Position


    

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_PROJECTILE then

            local tearVec = entity.Velocity * Vector(-1,-1)
            

            if (Mimas.Position - entity.Position):Length() < Mimas.Size + entity.Size then

                local MimasShot = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.ICE, 0, Mimas.Position, tearVec, Mimas):ToTear()

                MimasShot.FallingSpeed = -3

                MimasShot.TearFlags = TearFlags.TEAR_ORBIT | TearFlags.TEAR_ICE

                sprite:Play("Shoot", true)

                SFX:Play(SoundEffect.SOUND_CUTE_GRUNT, _, _, false, 1.5)

                entity:Remove()


            end

        end
        
    end

    if sprite:IsFinished() then

        sprite:Play("Idle", true)
        
    end

end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.MimasUpdate, RFTSFamiliars.TINY_MIMAS)