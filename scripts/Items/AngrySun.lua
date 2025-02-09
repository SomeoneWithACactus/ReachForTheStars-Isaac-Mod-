local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

SUN = {
    RANGE = 200,
    SPEED = 1.5,
}

---@param familiar EntityFamiliar
function mod:AngrySunInit(familiar)
    local sprite = familiar:GetSprite()

    sprite:Play("FloatDown", true)
    
    familiar:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

    familiar:AddToFollowers()

end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_INIT, mod.AngrySunInit, RFTSFamiliars.ANGRY_SUN)



---@param familiar EntityFamiliar
function mod:AngrySunOnUpdate(familiar)

    local sprite = familiar:GetSprite()

    local player = familiar.Player

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and entity:IsDead() == false and entity:HasEntityFlags(EntityFlag.FLAG_CHARM) == false then

            if (familiar.Position - entity.Position):Length() < familiar.Size + entity.Size then

                entity:AddEntityFlags(EntityFlag.FLAG_BURN)

            end

            if sprite:IsPlaying("FloatDown") and (familiar.Position - entity.Position):Length() < SUN.RANGE then
            
                sprite:Play("Attack", true)

            elseif sprite:IsPlaying("Attack") then

                if  sprite:IsEventTriggered("dash") then
                
                    familiar.Velocity = (entity.Position - familiar.Position):Normalized() * SUN.SPEED * 8 ---Go for the Enemy

                    SFX:Play(SoundEffect.SOUND_WAR_DASH)

                end

            end

        elseif sprite:IsFinished("Attack") then

            familiar.Velocity = Vector(0,0)

            sprite:Play("FloatDown", true)

        elseif entity:IsActiveEnemy() and entity:IsVulnerableEnemy() and entity:IsDead() then
            
            familiar.Velocity = Vector(0,0)

            sprite:Play("FloatDown", true)
        
        end
    end

    if sprite:IsPlaying("FloatDown") then
        
        familiar:FollowParent()

    end

    familiar.CollisionDamage = player.Damage * 0.70
    
end

mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.AngrySunOnUpdate, RFTSFamiliars.ANGRY_SUN)

function mod:GotHitSun(target,amount,flag,source,num)
    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        local sprite = player:GetSprite()

        local DoHit = true

        if player:HasCollectible(RFTSItems.ANGRY_SUN) == false then return end

        if target.Type == EntityType.ENTITY_PLAYER then

            for _, entity in ipairs(Isaac.GetRoomEntities()) do

                if  DoHit == true then

                    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, RFTSFamiliars.ANGRY_SUN, 0, player.Position, Vector.Zero, nil)

                    DoHit = false

                end

            end

        end

    end

end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.GotHitSun)

function mod:NewRoomSun()

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.ANGRY_SUN) == false then return end

        for _, entity in ipairs(Isaac.GetRoomEntities()) do

            if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == RFTSFamiliars.ANGRY_SUN then
                
                entity:Remove()

            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewRoomSun)