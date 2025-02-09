local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()


---@param player EntityPlayer
function mod:ScooperOnUse(_,_,player)
    
    local roll = math.random(1,3)

    if roll == 1 then

        Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                RFTSPickups.SPACE_ICRECREAM,
                SPACE_ICE_CREAM_SUBTYPE.NAPOLITAN, 
                player.Position,
                Vector((math.random(41)-21)/4,(math.random(41)-21)/4),
                nil)
        
    elseif roll == 2 then

        Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                RFTSPickups.SPACE_ICRECREAM,
                SPACE_ICE_CREAM_SUBTYPE.CHOCOMINT, 
                player.Position,
                Vector((math.random(41)-21)/4,(math.random(41)-21)/4),
                nil)
        
    elseif roll == 3 then

        Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                RFTSPickups.SPACE_ICRECREAM,
                SPACE_ICE_CREAM_SUBTYPE.SANDWICH, 
                player.Position,
                Vector((math.random(41)-21)/4,(math.random(41)-21)/4),
                nil)
        
    end

    SFX:Play(SoundEffect.SOUND_SLOTSPAWN)

    return true

end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.ScooperOnUse, RFTSItems.SPACE_SCOOPER)