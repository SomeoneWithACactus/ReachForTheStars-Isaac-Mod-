local mod = RegisterMod("Reach-for-the-Stars", 1)
local game = Game()
local room = game:GetRoom()

STAR_GAZING = {
    TIME = 30,
    SHOOT_TIME = 60,
}

---@param player EntityPlayer
function mod:StarGazinOnUpdate(player)

    if player:HasTrinket(RFTSTrinkets.STAR_GAZING) then

        if room:IsClear() == false and STAR_GAZING.TIME >= STAR_GAZING.SHOOT_TIME then

            local pitch = math.random() + 0.7

            SFX:Play(RFTSSounds.STAR_TEAR_SHOOT, 1, 2, false, pitch)

            local spawnStar = Isaac.Spawn(EntityType.ENTITY_TEAR, RFTSTears.STAR_TEAR, 0, room:GetRandomPosition(0), Vector.Zero, player)
	        local star = spawnStar:ToTear()

            star.CollisionDamage = player.Damage * 0.80
            star.Scale = math.min(player.Damage * 0.30, 2)
            star.TearFlags = player.TearFlags
            star.Height = -1000
	        star.FallingSpeed = 100
	        star.FallingAcceleration = 1
            star.Color = Color(
                1.0, ---Red
                1.0, ---Green
                0.2, ---Blue
                1.0,
                0.5, ---Red Offset
                0.0, ---Green Offset
                0.5  ----Blue Offset
                )

            STAR_GAZING.TIME = 0

        elseif STAR_GAZING.TIME < STAR_GAZING.SHOOT_TIME then
        
            STAR_GAZING.TIME = STAR_GAZING.TIME + 1

        end

    end

end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.StarGazinOnUpdate)