local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()

local SPEED_TO_ADD = 0.50

local function onStart(_)

    FirstTime = true

end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onStart)


---@param player EntityPlayer
function mod:WarpStarOnUse(_,_,player)
    
    player:UseCard(Card.CARD_EMPEROR)

    SFX:Play(RFTSSounds.WARP_STAR)

    return true

end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.WarpStarOnUse, RFTSItems.WARP_STAR)



function mod:NewFloorWarp()
    
    local room = game:GetRoom()

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.WARP_STAR) then

            if room:GetType() == RoomType.ROOM_BOSS and room:IsFirstVisit() then
                
                player:UseCard(Card.CARD_CHARIOT)

            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.NewFloorWarp)



---@param player EntityPlayer
function mod:WarpStarUpdate(player)

    if player:HasCollectible(RFTSItems.WARP_STAR) then
        
        if FirstTime == true then
            
            player:AddNullCostume(RFTSCostumes.WARP_STAR)

            SFX:Play(RFTSSounds.WARP_STAR_TAKE)

            FirstTime = false

        end

    end

    if player:HasCollectible(RFTSItems.WARP_STAR) == false and FirstTime == false then
        
        player:TryRemoveNullCostume(RFTSCostumes.WARP_STAR)

        FirstTime = true

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.WarpStarUpdate)



---@param player EntityPlayer
function mod:WarpStarCache(player,flag)
    if player:HasCollectible(RFTSItems.WARP_STAR) then

        if flag == CacheFlag.CACHE_SPEED then
            
            player.MoveSpeed = player.MoveSpeed + SPEED_TO_ADD

        end
        

        if flag == CacheFlag.CACHE_FLYING then
            
            player.CanFly = true

            

        end

    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.WarpStarCache)