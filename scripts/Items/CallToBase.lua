local game = Game()
local room = game:GetRoom()
require("scripts.Items.NovasController")

local DoTeleport = true

local LoseCharge = true

local AMOUNT = {

    PICKUP_MIN = 1,
    MEDIUM = 3,
    COLLECTIBLE_MAX = 6,
    TIME_PETRYFIED = 60,

}

---@param player EntityPlayer
---@param CallToBase EntityPickup
function Mod:CallToBaseOnUse(CallToBase, _, player)

    DoTeleport = true

    LoseCharge = true

    local Radius = Isaac.FindInRadius(player.Position,120,EntityPartition.PICKUP)

    if player:HasCollectible(CollectibleType.COLLECTIBLE_BIRTHRIGHT) then
        
        AMOUNT.PICKUP_MIN = 3
        
        AMOUNT.MEDIUM = 6

        AMOUNT.COLLECTIBLE_MAX = 9

        AMOUNT.TIME_PETRYFIED = 120

    end

    for _, entity in ipairs(Radius) do

        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant ~= RFTSPickups.STARS and entity:ToPickup():IsShopItem() == false then

            if entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType ~= CollectibleType.COLLECTIBLE_NULL then

                LoseCharge = false

                for i = 1, math.random(AMOUNT.MEDIUM, AMOUNT.COLLECTIBLE_MAX) do

                    Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    RFTSPickups.STARS,
                    0, 
                    entity.Position,
                    Vector((math.random(41)-21)/4,(math.random(41)-21)/4),
                    nil)

                end

                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector(0, 0), player)

                SFX:Play(SoundEffect.SOUND_ANIMA_BREAK)

                DoTeleport = false

                entity:Remove()

            elseif entity.Variant ~= PickupVariant.PICKUP_COLLECTIBLE and 
            (entity.Variant ~= PickupVariant.PICKUP_BIGCHEST 
            or (entity.Variant ~= PickupVariant.PICKUP_COIN and entity.SubType ~= RFTSPickups.SPACE_CURRENCY)
            or (entity.Variant ~= PickupVariant.PICKUP_KEY and entity.SubType ~= RFTSPickups.ASTRAL_KEY)) then

                for i = 1, math.random(AMOUNT.PICKUP_MIN, AMOUNT.MEDIUM) do

                    if game:IsGreedMode() then

                        if room:IsClear() then
                            
                            local roll = math.random(1,4)

                            if roll == 1 then
                                
                                Isaac.Spawn(
                                    EntityType.ENTITY_PICKUP,
                                    PickupVariant.PICKUP_COIN,
                                    RFTSPickups.SPACE_CURRENCY, 
                                    entity.Position,
                                    Vector.Zero,
                                    nil)

                                ZipZipLightBeam(entity.Position)

                                DoTeleport = false

                                LoseCharge = false

                            else

                                Isaac.Spawn(
                                    EntityType.ENTITY_PICKUP,
                                    RFTSPickups.STARS,
                                    0, 
                                    entity.Position,
                                    Vector((math.random(41)-21)/4,(math.random(41)-21)/4),
                                    nil)

                                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector(0, 0), player)

                                SFX:Play(SoundEffect.SOUND_ANIMA_BREAK)

                                entity:Remove()

                                DoTeleport = false

                                LoseCharge = false

                            end

                        end

                    else
                
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            RFTSPickups.STARS,
                            0, 
                            entity.Position,
                            Vector((math.random(41)-21)/4,(math.random(41)-21)/4),
                            nil)

                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector(0, 0), player)

                        SFX:Play(SoundEffect.SOUND_ANIMA_BREAK)

                        entity:Remove()

                        DoTeleport = false

                        LoseCharge = false

                    end

                end

            end
        
        end
        
    end

    if DoTeleport == true then

        if room:IsClear() == false then
            
            for _, entity in ipairs(Isaac.GetRoomEntities()) do

                if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
                    
                    entity:AddFreeze(EntityRef(player), AMOUNT.TIME_PETRYFIED)

                    ZipZipLightBeam(entity.Position)

                end

                if entity.Type == EntityType.ENTITY_PROJECTILE then
                    
                    entity.Velocity = Vector.Zero

                    entity.Color = Color(
                        0.0, ---Red
                        0.8, ---Green
                        0.8, ---Blue
                        1.0,
                        0.0, ---Red Offset
                        0.5, ---Green Offset
                        0.0  ----Blue Offset
                        )

                end
                
            end

        else

            if game:IsGreedMode() then

                player:UseCard(Card.CARD_HERMIT,UseFlag.USE_NOANIM)

                SFX:Stop(SoundEffect.SOUND_HERMIT)


            else

                player:UseCard(Card.CARD_FOOL,UseFlag.USE_NOANIM)

                SFX:Stop(SoundEffect.SOUND_FOOL)

            end

        end

    end

    return {
        Discharge = LoseCharge,
        Remove = false,
        ShowAnim = true
    }
end

Mod:AddCallback(ModCallbacks.MC_USE_ITEM, Mod.CallToBaseOnUse, RFTSItems.CALL_TO_BASE)