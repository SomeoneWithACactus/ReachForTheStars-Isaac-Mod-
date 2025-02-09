local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

---@param player EntityPlayer
function mod:OnUpdateSaturnPeach(player)

    if player:HasCollectible(RFTSItems.SATURN_PEACH) == false then return end

    
    local room = game:GetRoom()

    if room:IsClear() == false then
        if game:GetFrameCount() % 90 == 0 then

            local position = Isaac.GetFreeNearPosition(player.Position, math.random(64, 250))
        
            Isaac.Spawn(EntityType.ENTITY_PICKUP, RFTSPickups.SATURN_PEACH, 0, position, Vector.Zero, nil)

        end

    end

end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnUpdateSaturnPeach)
