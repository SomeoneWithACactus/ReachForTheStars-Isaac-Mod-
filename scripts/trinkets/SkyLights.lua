local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()
local room = game:GetRoom()
require("scripts.Items.NovasController")

function mod:SkyLightsNewRoom()

    local player = Isaac.GetPlayer(0)

    if player:HasTrinket(RFTSTrinkets.SKY_LIGHTS) then

        if room:IsClear() == false then

            local roll = math.random(1,4)

            if roll <= 2 then
            
                for _, entity in ipairs(Isaac.GetRoomEntities()) do

                    if entity:IsActiveEnemy() and entity:IsVulnerableEnemy() then
                    
                        entity:AddFreeze(EntityRef(player), 120)

                        ZipZipLightBeam(entity.Position)

                    end

                end
                
            end

        end

    end
    
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SkyLightsNewRoom)