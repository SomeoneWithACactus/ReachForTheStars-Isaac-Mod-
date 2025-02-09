local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

function ZipZipLightBeam(position)
    
    local UFO_BEAM = Isaac.Spawn(EntityType.ENTITY_EFFECT, RFTSEffects.LIGHT_UFO, 0, position, Vector.Zero, player):ToEffect()

                UFO_BEAM.Color = Color( ---Color of the SKYCRACK
                         0.0, ---Red
                         0.7, ---Green
                         0.2, ---Blue
                         1.0,
                         0.0, ---Red Offset
                         0.2, ---Green Offset
                         0.2  ----Blue Offset
                         )

                SFX:Play(RFTSSounds.ALIEN_REROLL, 0.8)

                game:Darken(1,60)

end


---@param player EntityPlayer
function mod:NovasControllerOnUse(_,_,player)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do

        if entity.Type == EntityType.ENTITY_PICKUP and entity:ToPickup():IsShopItem() == false then

            if (player.Position - entity.Position):Length() < 200 then
            
                if entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType ~= CollectibleType.COLLECTIBLE_NULL then

                    if entity.SubType == CollectibleType.COLLECTIBLE_SOY_MILK ---MILKY_WAY_MILK
                    or  entity.SubType == CollectibleType.COLLECTIBLE_ALMOND_MILK then
                    
                        SpawnCollectable(RFTSItems.MILKY_WAY_MILK, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    elseif entity.SubType == CollectibleType.COLLECTIBLE_POLYPHEMUS then ---URANIA
                    
                        SpawnCollectable(RFTSItems.URANIA, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    elseif entity.SubType == CollectibleType.COLLECTIBLE_BIRDS_EYE ---ALIEN PEPPER
                    or  entity.SubType == CollectibleType.COLLECTIBLE_GHOST_PEPPER then
                    
                        SpawnCollectable(RFTSItems.ALIEN_PEPPER, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    elseif entity.SubType == CollectibleType.COLLECTIBLE_TINY_PLANET then ---TINY MIMAS
                    
                        SpawnCollectable(RFTSItems.TINY_MIMAS, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    elseif entity.SubType == CollectibleType.COLLECTIBLE_DEAD_BIRD ---ANGRY SUN
                    or entity.SubType == CollectibleType.COLLECTIBLE_ANGRY_FLY then
                    
                        SpawnCollectable(RFTSItems.ANGRY_SUN, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    elseif entity.SubType == CollectibleType.COLLECTIBLE_GODHEAD ---CELESTIAL MASK
                    or entity.SubType == CollectibleType.COLLECTIBLE_MONSTRANCE
                    or entity.SubType == CollectibleType.COLLECTIBLE_SALVATION
                    or entity.SubType == CollectibleType.COLLECTIBLE_INFAMY then 
                    
                        SpawnCollectable(RFTSItems.CELESTIAL_MASK, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    elseif entity.SubType == CollectibleType.COLLECTIBLE_PLUTO ---ERIS MARK
                    or entity.SubType == CollectibleType.COLLECTIBLE_MINI_MUSH then 
                    
                        SpawnCollectable(RFTSItems.ERIS, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    elseif entity.SubType == CollectibleType.COLLECTIBLE_TELEPORT ---MOON'S PEARL
                    or entity.SubType == CollectibleType.COLLECTIBLE_TELEPORT_2
                    or entity.SubType == CollectibleType.COLLECTIBLE_CURSED_EYE then
                    
                        SpawnCollectable(RFTSItems.MOONS_PEARL, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    elseif entity.SubType == CollectibleType.COLLECTIBLE_TECH_X ---VIRTUAL_KID
                    or entity.SubType == CollectibleType.COLLECTIBLE_GAMEKID then
                    
                        SpawnCollectable(RFTSItems.VIRTUAL_KID, entity.Position)

                        ZipZipLightBeam(entity.Position)

                        entity:Remove()

                    else

                        for i = 1, 5 do

                        local roll = math.random(1,5)

                            if roll == 1 then
                
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,
                                PickupVariant.PICKUP_KEY,
                                RFTSPickups.ASTRAL_KEY,
                                entity.Position,
                                Vector((math.random(40)-21)/4,(math.random(40)-21)/4),
                                player)

                            elseif roll == 2 then
                
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,
                                PickupVariant.PICKUP_COIN,
                                RFTSPickups.SPACE_CURRENCY,
                                entity.Position,
                                Vector((math.random(40)-21)/4,(math.random(40)-21)/4),
                                player)

                            elseif roll == 3 then
                
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,
                                PickupVariant.PICKUP_TAROTCARD,
                                RFTSConsumables.POCKET_8_BALL,
                                entity.Position,
                                Vector((math.random(40)-21)/4,(math.random(40)-21)/4),
                                player)

                            elseif roll == 4 then
                
                                Isaac.Spawn(EntityType.ENTITY_PICKUP,
                                PickupVariant.PICKUP_TAROTCARD,
                                RFTSConsumables.BLESSING_FROM_THE_STARS,
                                entity.Position,
                                Vector((math.random(40)-21)/4,(math.random(40)-21)/4),
                                player)

                            elseif roll == 5 then
                
                                TrinketSpaceRandom(entity.Position,Vector((math.random(40)-21)/4,(math.random(40)-21)/4))

                            end

                        end

                        ZipZipLightBeam(entity.Position)

                        SFX:Play(SoundEffect.SOUND_ANIMA_BREAK)

                        entity:Remove()

                    end


                elseif entity.Variant == PickupVariant.PICKUP_COIN then

                    Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COIN,
                            RFTSPickups.SPACE_CURRENCY,
                            entity.Position,
                            Vector(0, 0),
                            player)

                    ZipZipLightBeam(entity.Position)

                    entity:Remove()



                elseif entity.Variant == PickupVariant.PICKUP_KEY then

                    Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_KEY,
                            RFTSPickups.ASTRAL_KEY,
                            entity.Position,
                            Vector(0, 0),
                            player)

                    ZipZipLightBeam(entity.Position)

                    entity:Remove()


                elseif entity.Variant == PickupVariant.PICKUP_TAROTCARD then

                    local roll = math.random(1,5)

                    if roll == 1 then
                    
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.BLESSING_FROM_THE_STARS,
                            entity.Position,
                            Vector(0, 0),
                            player)

                    elseif roll == 2 then
                    
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.POCKET_8_BALL,
                            entity.Position,
                            Vector(0, 0),
                            player)

                    elseif roll == 3 then
                    
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.THREE_OF_SUNS,
                            entity.Position,
                            Vector(0, 0),
                            player)

                    elseif roll == 4 then
                    
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.THE_BELT,
                            entity.Position,
                            Vector(0, 0),
                            player)

                    elseif roll == 5 then
                    
                        Isaac.Spawn(EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_TAROTCARD,
                            RFTSConsumables.THE_CONSTELLATION,
                            entity.Position,
                            Vector(0, 0),
                            player)

                    end

                    ZipZipLightBeam(entity.Position)

                    entity:Remove()


                end

            end

        end
        
    end

    return true
    
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.NovasControllerOnUse, RFTSItems.NOVAS_CONTROLER)