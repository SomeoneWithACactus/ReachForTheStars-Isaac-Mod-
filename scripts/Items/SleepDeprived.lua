local mod = RegisterMod("Reach for the Stars", 1)
local game = Game()

local SD_SPEED_MULT = 0.85
local SD_SPEED_DOWN = 0.05


---@param player EntityPlayer
function mod:SleepDeprivedOnCache(player, flag)

    if player:HasCollectible(RFTSItems.SLEEP_DEPRIVED) then
        
        if flag == CacheFlag.CACHE_SPEED then
            
            player.MoveSpeed = player.MoveSpeed * SD_SPEED_MULT - SD_SPEED_DOWN

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.SleepDeprivedOnCache)


function mod:SleepDeprivedOnUpdate()

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(RFTSItems.SLEEP_DEPRIVED) then

            for _, entity in ipairs(Isaac.GetRoomEntities()) do
            
                if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then

                    local roll = math.random(100)

                    if roll <= 50 then
                
                    entity:AddEntityFlags(EntityFlag.FLAG_SLOW)

                    end

                end

            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SleepDeprivedOnUpdate)