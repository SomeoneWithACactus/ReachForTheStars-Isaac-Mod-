Mod = RegisterMod("Reach-for-the-Stars", 1)
SFX = SFXManager()
local game = Game()




---------INCLUDE CONSTANTS----------
include("scripts.constants")

-------GLOBAL FUNCTIONS--------

function ShootTearColor(vectordirection, speed, teartype, position, flag, DoArc, color, damage) ---Shoot a Tear with Color

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        local direction =  vectordirection * speed + player:GetTearMovementInheritance(vectordirection)

        local Tear = Isaac.Spawn(EntityType.ENTITY_TEAR, teartype, 0, position, direction, nil):ToTear()

        Tear.TearFlags = flag

        Tear.Color = color

        Tear.CollisionDamage = damage
        

        if DoArc == true then

            Tear.FallingSpeed = -15

            Tear.FallingAcceleration = 1

        else

            Tear.FallingSpeed = 0

            Tear.FallingAcceleration = 0

        end

    end
end

function ShootTear(vectordirection, speed, teartype, position, flag, DoArc) ---Shoot a tear

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        local direction =  vectordirection * speed + player:GetTearMovementInheritance(vectordirection)

        local Tear = Isaac.Spawn(EntityType.ENTITY_TEAR, teartype, 0, position, direction, nil):ToTear()

        Tear.TearFlags = flag

        if DoArc == true then

            Tear.FallingSpeed = -15

            Tear.FallingAcceleration = 1

        else

            Tear.FallingSpeed = 0

            Tear.FallingAcceleration = 0

        end

    end
end



-------FUNCTION TO SPAWN A COLLECTABLE WITHOUT MAKING A SHITTON OF CODE-------

function SpawnCollectable(collectable, position) ---Spawn a Collectable

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(collectable) == false then

            Isaac.Spawn(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            collectable,
            position,
            Vector(0, 0),
            player)

        else

            Isaac.Spawn(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            RFTSItems.EXPLORER_BREAKFAST,
            position,
            Vector(0, 0),
            player)

        end

        SFX:Play(SoundEffect.SOUND_POWERUP_SPEWER)
    end
    
end


function ShootTears(tears,position,sfx,speed,doExtraEffects, InherentTearFlags, doColor, Color) ---Spawn 8 tears on all directions

    for i = 0, game:GetNumPlayers() - 1 do

        local player = Isaac.GetPlayer(i)

        local directionright =  Vector(1,0) * speed + player:GetTearMovementInheritance(Vector(1,0))
        local directiondiagright =  Vector(1,1) * speed + player:GetTearMovementInheritance(Vector(1,1))
        local directionleft =  Vector(-1,0) * speed + player:GetTearMovementInheritance(Vector(-1,0))
        local directiondiagleft =  Vector(-1,-1) * speed + player:GetTearMovementInheritance(Vector(-1,1))
        local directiondown=  Vector(0,1) * speed + player:GetTearMovementInheritance(Vector(0,1))
        local directiondiagdown=  Vector(-1,1) * speed + player:GetTearMovementInheritance(Vector(-1,1))
        local directionup =  Vector(0,-1) * speed + player:GetTearMovementInheritance(Vector(0,-1))
        local directiondiagup =  Vector(1,-1) * speed + player:GetTearMovementInheritance(Vector(1,-1))

        TEARS = {
        tear1 = Isaac.Spawn(EntityType.ENTITY_TEAR, tears, 0, position, directionright, nil):ToTear(),
        tear2 = Isaac.Spawn(EntityType.ENTITY_TEAR, tears, 0, position, directionleft, nil):ToTear(),
        tear3 = Isaac.Spawn(EntityType.ENTITY_TEAR, tears, 0, position, directiondown, nil):ToTear(),
        tear4 = Isaac.Spawn(EntityType.ENTITY_TEAR, tears, 0, position, directionup, nil):ToTear(),

        tear5 = Isaac.Spawn(EntityType.ENTITY_TEAR, tears, 0, position, directiondiagright, nil):ToTear(),
        tear6 = Isaac.Spawn(EntityType.ENTITY_TEAR, tears, 0, position, directiondiagleft, nil):ToTear(),
        tear7 = Isaac.Spawn(EntityType.ENTITY_TEAR, tears, 0, position, directiondiagdown, nil):ToTear(),
        tear8 = Isaac.Spawn(EntityType.ENTITY_TEAR, tears, 0, position, directiondiagup, nil):ToTear(),
        }

        if InherentTearFlags == true then

            TEARS.tear1.TearFlags = player.TearFlags

            TEARS.tear2.TearFlags = player.TearFlags

            TEARS.tear3.TearFlags = player.TearFlags

            TEARS.tear4.TearFlags = player.TearFlags

            TEARS.tear5.TearFlags = player.TearFlags

            TEARS.tear6.TearFlags = player.TearFlags

            TEARS.tear7.TearFlags = player.TearFlags

            TEARS.tear8.TearFlags = player.TearFlags

        end

        if doColor == true then
            
            TEARS.tear1.Color = Color

            TEARS.tear2.Color = Color

            TEARS.tear3.Color = Color

            TEARS.tear4.Color = Color

            TEARS.tear5.Color = Color

            TEARS.tear6.Color = Color

            TEARS.tear7.Color = Color

            TEARS.tear8.Color = Color

        end

        if doExtraEffects == true then

            if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then

                for Angle = 45, 45 + 270, 90 do
            
                local LASER = EntityLaser.ShootAngle(
                LaserVariant.BRIM_TECH,
                player.Position,
                Angle,
                30,
                Vector.Zero,
                player
                )
    
               LASER.Color = Color(
                    1.5, ---Red
                    0.7, ---Green
                    0.0, ---Blue
                    1.0,
                    0.0, ---Red Offset
                    0.0, ---Green Offset
                    0.0  ----Blue Offset
                    )

                LASER.CollisionDamage = player.Damage * 0.50

                end
                
            elseif player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY)
            or player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY_2) 
            or player:HasCollectible(CollectibleType.COLLECTIBLE_TECH_X) then

                for Angle = 45, 45 + 270, 90 do
            
                local LASER = EntityLaser.ShootAngle(
                LaserVariant.THIN_RED,
                player.Position,
                Angle,
                30,
                Vector.Zero,
                player
                )
    
                LASER.Color = Color(
                    1.5, ---Red
                    0.7, ---Green
                    0.0, ---Blue
                    1.0,
                    0.0, ---Red Offset
                    0.0, ---Green Offset
                    0.0  ----Blue Offset
                    )

                LASER.CollisionDamage = player.Damage * 0.50

                end
                
            elseif player:HasCollectible(CollectibleType.COLLECTIBLE_REVELATION) then

                for Angle = 45, 45 + 270, 90 do
            
                local LASER = EntityLaser.ShootAngle(
                LaserVariant.LIGHT_RING,
                player.Position,
                Angle,
                30,
                Vector.Zero,
                player
                )
    
                LASER.Color = Color(
                    1.5, ---Red
                    0.7, ---Green
                    0.0, ---Blue
                    1.0,
                    0.0, ---Red Offset
                    0.0, ---Green Offset
                    0.0  ----Blue Offset
                    )

                LASER.CollisionDamage = player.Damage * 0.50

                end
                
            end

        end

    end

    SFX:Play(sfx)
    
end


function BlessingEffect(str, str2, curse, blessing) ---Vannish a Curse and Trigger a blessing

    local level = game:GetLevel()

    game:GetHUD():ShowItemText(str, str2)

    SFX:Play(SoundEffect.SOUND_POWERUP1)

    level:RemoveCurses(curse)

    level:AddCurse(blessing, false)

end



function RerollColectible(collectible)

    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        
        if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then

            local player = Isaac.GetPlayer(0)

            if player:HasCollectible(collectible) == false then

                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, entity.Position, Vector.Zero, nil)

                entity:Remove()

            end

        end

    end
    
end


function TrinketSpaceRandom(pos, vel)

    local player = Isaac.GetPlayer(0)
    
    local roll = math.random(1,15)

    local trinket = RFTSTrinkets.MINI_MINILASER


    if roll == 1 then
        
        trinket = RFTSTrinkets.MINI_MINILASER

    elseif roll == 2 then
        
        trinket = RFTSTrinkets.ALIEN_WORM
        
    elseif roll == 3 then
        
        trinket = RFTSTrinkets.LAZY_ALIEN_WORM
        
    elseif roll == 4 then
        
        trinket = RFTSTrinkets.AMBASSADORS_CROWN
        
    elseif roll == 5 then
        
        trinket = RFTSTrinkets.SKY_LIGHTS
        
    elseif roll == 6 then
        
        trinket = RFTSTrinkets.STAR_GAZING
        
    end

    if player:HasTrinket(trinket) == false then

        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinket, pos, vel, nil)

    else

        Isaac.Spawn(EntityType.ENTITY_PICKUP,
                    RFTSPickups.SPACE_ICRECREAM,
                    SPACE_ICE_CREAM_SUBTYPE.SANDWICH,
                    pos,
                    vel,
                    nil)

    end

end




-----------CHARACTERS------------
include("scripts.characters.Nova")
include("scripts.slots.Saturn")

--------------SLOT--------------
include("scripts.slots.LittleShip")

-------------ITEMS---------------
include("scripts.Items.CallToBase")
include("scripts.Items.MilkyWayMilk")
include("scripts.Items.Urania")
include("scripts.Items.AlienPepper")
include("scripts.Items.TinyMimas")
include("scripts.Items.SleepDeprived")
include("scripts.Items.UFOBombs")
include("scripts.Items.ExplorerBreakfast")
include("scripts.Items.AngrySun")
include("scripts.Items.SaturnsPeach")
include("scripts.Items.CelestialMask")
include("scripts.Items.Eris")
include("scripts.Items.SpaceScooper")
include("scripts.Items.MoonsPearl")
include("scripts.Items.WarpStar")
include("scripts.Items.VirtualKid")
include("scripts.Items.NovasController")


------------TRINKETS-------------
include("scripts.trinkets.MiniMiniLaser")
include("scripts.trinkets.AlienWorm")
include("scripts.trinkets.LazyAlienWorm")
include("scripts.trinkets.AmbassadorCrown")
include("scripts.trinkets.SkyLights")
include("scripts.trinkets.StarGazing")

------------PICKUPS--------------
include("scripts.pickups.Stars")
include("scripts.pickups.SpaceCurrency")
include("scripts.pickups.AstralKey")
include("scripts.pickups.SaturnsPeachPickup")
include("scripts.pickups.SpaceIceCream")

------------TEARS------------
include("scripts.Tear.StarTear")
include("scripts.Tear.PeachSeed")
include("scripts.Tear.Pearl")

----------BLESSINGS---------
include("scripts.BlessingFromTheStars")

---------CONSUMABLES---------
include("scripts.pickups.Blessings")
include("scripts.pickups.Pocket8Ball")
include("scripts.pickups.ThreeOfSuns")
include("scripts.pickups.TheBelt")
include("scripts.pickups.TheConstellation")