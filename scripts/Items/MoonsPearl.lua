local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()


---@param player EntityPlayer
function mod:PearlOnUse(_,_,player)

    if player:IsHoldingItem() then
        
        player:AnimateCollectible(RFTSItems.MOONS_PEARL, "HideItem")

    else

        player:AnimateCollectible(RFTSItems.MOONS_PEARL, "LiftItem")

    end

    return false
    
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PearlOnUse, RFTSItems.MOONS_PEARL)

---@param player EntityPlayer
function mod:PearlOnUpdate(player)

    if player:HasCollectible(RFTSItems.MOONS_PEARL) then

        if player:IsHoldingItem() then

            local shootdirection = player:GetFireDirection()

            local dirpearl = Vector(0,1)

            if shootdirection ~= Direction.NO_DIRECTION then
    
                if shootdirection == Direction.LEFT then

                    dirpearl = Vector(-1,0)
        
                elseif shootdirection == Direction.RIGHT then

                    dirpearl = Vector(1,0)
        
                elseif shootdirection == Direction.UP then

                    dirpearl = Vector(0,-1)
        
                elseif shootdirection == Direction.DOWN then

                    dirpearl = Vector(0,1)
        
                end



                ShootTear(dirpearl,15,RFTSTears.MOON_PEARL, player.Position + Vector(0,-15), TearFlags.TEAR_PIERCING, true)

                SFX:Play(RFTSSounds.THROW)

                player:AnimateCollectible(RFTSItems.MOONS_PEARL, "HideItem")


            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PearlOnUpdate)