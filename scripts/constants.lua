
RFTSCharacters = {
    NOVA = Isaac.GetPlayerTypeByName("Nova", false),
}

RFTSItems = {
    CALL_TO_BASE = Isaac.GetItemIdByName("Call to Base"),
    MILKY_WAY_MILK = Isaac.GetItemIdByName("Milky Way Milk"),
    URANIA = Isaac.GetItemIdByName("Urania"),
    ALIEN_PEPPER = Isaac.GetItemIdByName("Alien Pepper"),
    TINY_MIMAS = Isaac.GetItemIdByName("Tiny Mimas"),
    SLEEP_DEPRIVED = Isaac.GetItemIdByName("Sleep Deprived"),
    UFO_BOMBS = Isaac.GetItemIdByName("UFO Bombs"),
    EXPLORER_BREAKFAST = Isaac.GetItemIdByName("A explorer breakfast"),
    ANGRY_SUN = Isaac.GetItemIdByName("Angry Sun"),
    SATURN_PEACH = Isaac.GetItemIdByName("Saturn's Peach"),
    CELESTIAL_MASK = Isaac.GetItemIdByName("Celestial Mask"),
    ERIS = Isaac.GetItemIdByName("Eris' Mark"),
    SPACE_SCOOPER = Isaac.GetItemIdByName("Space Scooper"),
    MOONS_PEARL = Isaac.GetItemIdByName("Moon's Pearl"),
    WARP_STAR = Isaac.GetItemIdByName("Warp Star"),
    VIRTUAL_KID = Isaac.GetItemIdByName("Virtual Kid"),
    NOVAS_CONTROLER = Isaac.GetItemIdByName("Nova's Controller"),
}

RFTSTrinkets = {
    MINI_MINILASER = Isaac.GetTrinketIdByName("MINI MINILASER"),
    ALIEN_WORM = Isaac.GetTrinketIdByName("Alien Worm"),
    LAZY_ALIEN_WORM = Isaac.GetTrinketIdByName("Lazy Alien Worm"),
    AMBASSADORS_CROWN = Isaac.GetTrinketIdByName("Ambassador's Crown"),
    SKY_LIGHTS = Isaac.GetTrinketIdByName("Sky Lights"),
    STAR_GAZING = Isaac.GetTrinketIdByName("Stargazing"),
}

RFTSCostumes = {
    NOVA_HAIR = Isaac.GetCostumeIdByPath("gfx/characters/nova_hair.anm2"),
    NOVA_BODY = Isaac.GetCostumeIdByPath("gfx/characters/nova_body.anm2"),
    WARP_STAR = Isaac.GetCostumeIdByPath("gfx/characters/014_warpstar.anm2"),
}

RFTSPickups = {
    STARS = Isaac.GetEntityVariantByName("Star"),
    SPACE_CURRENCY = 20,
    ASTRAL_KEY = 20,
    SATURN_PEACH = Isaac.GetEntityVariantByName("Saturns Peach"),
    SPACE_ICRECREAM = 120,
}

SPACE_ICE_CREAM_SUBTYPE = {
    NAPOLITAN = 01,
    CHOCOMINT = 02,
    SANDWICH = 03,
}

RFTSSounds = {
    STAR_PICKUP = Isaac.GetSoundIdByName("STAR_PICKUP"),
    STAR_APPEAR = Isaac.GetSoundIdByName("STAR_APPEAR"),
    GLASS_CLICK = Isaac.GetSoundIdByName("GLASS_CLICK"),
    STAR_TEAR_SHOOT = Isaac.GetSoundIdByName("STAR_TEAR_SHOOT"),
    UFO_BOMBS_TIMER = Isaac.GetSoundIdByName("UFO_BOMBS_TIMER"),
    SPLAT = Isaac.GetSoundIdByName("SPLAT"),
    MUNCH = Isaac.GetSoundIdByName("MUNCH"),
    THROW = Isaac.GetSoundIdByName("THROW"),
    PEARL_TELEPORT = Isaac.GetSoundIdByName("PEARL_TELEPORT"),
    WARP_STAR = Isaac.GetSoundIdByName("WARP_STAR"),
    WARP_STAR_TAKE = Isaac.GetSoundIdByName("WARP_STAR_TAKE"),
    LITTLE_SHIP_APPEARS = Isaac.GetSoundIdByName("LITTLE_SHIP_APPEARS"),
    ALIEN_REROLL = Isaac.GetSoundIdByName("ALIEN_REROLL"),
    CONSTELLATION_HIT = Isaac.GetSoundIdByName("CONSTELLATION_HIT"),
}

RFTSTears = {
    STAR_TEAR = Isaac.GetEntityVariantByName("Star Tear"),
    STUFFED_TEAR = Isaac.GetEntityVariantByName("Stuffed Tear"),
    PEACH_SEED = Isaac.GetEntityVariantByName("Peach Nut"),
    MOON_PEARL = Isaac.GetEntityVariantByName("Moon Pearl"),
}

RFTSFamiliars = {
    TINY_MIMAS = Isaac.GetEntityVariantByName("Tiny Mimas"),
    ANGRY_SUN = Isaac.GetEntityVariantByName("Angry Sun"),
    DISNOMIA = Isaac.GetEntityVariantByName("Disnomia"),
}

RFTSItemConfig = {
    TINY_MIMAS = Isaac.GetItemConfig():GetCollectible(RFTSItems.TINY_MIMAS),
    ANGRY_SUN = Isaac.GetItemConfig():GetCollectible(RFTSItems.ANGRY_SUN),
    ERIS = Isaac.GetItemConfig():GetCollectible(RFTSItems.ERIS),
}

BLESSINGS = {
    BLESS_OF_THE_SUN = 1 << (Isaac.GetCurseIdByName("Bless of the Sun") - 1),
    BLESS_OF_THE_ENLIGHTED = 3 << (Isaac.GetCurseIdByName("Bless of the Enlighted") - 1),
    BLESS_OF_THE_EXPLORER = 37 << (Isaac.GetCurseIdByName("Bless of the Explorer") - 1),
    BLESS_OF_THE_KNOWLEGE = 35 << (Isaac.GetCurseIdByName("Bless of the Knowledge") - 1),
}

RFTSConsumables = {
    BLESSING_FROM_THE_STARS = Isaac.GetCardIdByName("Blessing"),
    POCKET_8_BALL = Isaac.GetCardIdByName("8ball"),
    THREE_OF_SUNS = Isaac.GetCardIdByName("ThreeSuns"),
    THE_BELT = Isaac.GetCardIdByName("TheBelt"),
    THE_CONSTELLATION = Isaac.GetCardIdByName("TheConstellation"),
}

RFTSNpc = {
    SATURN = Isaac.GetEntityTypeByName("Saturn"),
    LITTLE_SHIP = Isaac.GetEntityTypeByName("Ship Pack"),

    LITTLE_SHIP_VAR = Isaac.GetEntityVariantByName("Ship Pack"),
}

BeggarState = {
    IDLE = 0,
    PAYNOTHING = 2,
    PAYPRIZE = 3,
    PRIZE = 4,
    TELEPORT = 5
}

RFTSEffects = {
    LIGHT_UFO = Isaac.GetEntityVariantByName("LIGHT_UFO"),
    
}


-----EXTERNAL ITEM DESCRIPTIONS-----

if EID then
    
    EID:addCollectible(RFTSItems.CALL_TO_BASE, "Turns every Pickup in the room into Star Bits#1-3 Star Bits on pickups and 3-6 Star Bits on collectibles#on uncleared rooms petrified all enemies in the room")
    EID:addCollectible(RFTSItems.MILKY_WAY_MILK, "↑ {{Tears}} 0.50x Max Fire Delay Multiplier #↓ {{Damage}} 0.35x Damage Multiplier# !!! Grants Homing and Piercing Tears")
    EID:addCollectible(RFTSItems.URANIA, "↑ {{Damage}} +0.5 Damage UP #↑ 1.8x Damage Multiplier #↓ {{Tears}} 4x Max Fire Delay Multiplier #↓ {{Shotspeed}} -0.50 Shot Speed # !!! Grants Star Tears that gain more Damage by passing throught enemies")
    EID:addCollectible(RFTSItems.ALIEN_PEPPER, "{{Luck}} Luck based chance to shoot a Stuffed Tear #Stuffed Tears Explodes on 8 green fires #Shoot 100% of the Time at 7 Luck")
    EID:addCollectible(RFTSItems.TINY_MIMAS, "Grants a Planet Familiar that blocks Shots #If the Mimas blocks a shot, it will shoot a Orbiting Tear that can Freeze the enemies")
    EID:addCollectible(RFTSItems.SLEEP_DEPRIVED, "↓ {{Speed}} -0.05 Speed Down # ↓ 0.85x Speed Multiplier #Upon entering a new room, 50% chance per enemy of being applied slowing effect")
    EID:addCollectible(RFTSItems.UFO_BOMBS, "+5 Bombs#Grants Homing to Isaac's Bombs#Bomb's explosion now shoots Star Tears at Random Directions and triggers a Light Beam on its Explosion Position")
    EID:addCollectible(RFTSItems.EXPLORER_BREAKFAST, "Grants one Full Heart Container # !!! Grants a small Damage Buff to Milk Related Items")
    EID:addCollectible(RFTSItems.ANGRY_SUN, "When Isaac's Recieves Damage spawns a Sun Familiar that Charges against the Enemies")
    EID:addCollectible(RFTSItems.SATURN_PEACH, "Saturn Peachs Pickups start appearing on uncleared room every 3 Seconds #On Pickup they explodes on 8 Seed Shots on all directions#The Seed Shots inherits Isaac's tear effects")
    EID:addCollectible(RFTSItems.CELESTIAL_MASK, "↑ {{Damage}} +1 Damage UP # ↑ 1.5x Damage Multiplier #↓ {{Speed}} -0.10 Speed Down #Grants Homing and Orbital Tears#{{Trinket68}} Gulps Super Magnet on Pickup #Grants an Green Aura that Slows enemies and tears#Enemies that dies in this aura creates two light beams on a X form #Every 10 shots Isaac shoots a Spear Tear that creates a black hole on collision")
    EID:addCollectible(RFTSItems.ERIS, "Grants a Dysnomia Familiar that Shoots tears with the God's Flesh Effect #Every 25 shots, she creates a gas cloud that does the God's Flesh effect to close enemies#Enemies with the God's Flesh effect have a chance to spawn up to 3 MiniIsaacs on death")
    EID:addCollectible(RFTSItems.SPACE_SCOOPER, "Spawns one Random Space Ice Cream #Possible Flavors are: #Napolitan Space Ice Cream: One Half of a Random Heart #Chocomint Space Ice Cream: +0.25 Luck UP #Space Ice Cream Sandwich: Spawns one MiniIsaac")
    EID:addCollectible(RFTSItems.MOONS_PEARL, "On Use Teleports Isaac to the direction they throws it #Does Half a Heart of Damage to Isaac on Teleport#Haves a Chance to Spawn a Friendly Charger on Teleport")
    EID:addCollectible(RFTSItems.WARP_STAR, "Grants Isaac Flight while held #On use teleports Isaac to the boss room #While held, triggers the Chariot effect upon entering a Boss room")
    EID:addCollectible(RFTSItems.VIRTUAL_KID, "On use constantly shoots four lasers that spin on 360 from Isaac and grants weakness to all enemies in the room # Each laser does x1.5 of Isaac's Damage #Hurts Isaac every 15 seconds while the effect is active #The effect is removed upon exit the current room")


    EID:addTrinket(RFTSTrinkets.MINI_MINILASER, "{{Luck}} Luck based chance to shoot a technology laser that does the God's Flesh effect")
    EID:addTrinket(RFTSTrinkets.ALIEN_WORM, "↑ {{Tears}} 0.95x Max Fire Delay Multiplier # ↑ {{Shotspeed}} +2.5 Shot Speed UP# Isaac's tear damage increases progressively while on air# Isaac's Shot Speed now is a damage multiplier#!!! If you are playing as Nova, you will recieve a 1.75 Damage UP instead")
    EID:addTrinket(RFTSTrinkets.LAZY_ALIEN_WORM, "Isaac's tears doubles on Size#Isaac's tears now stop mid-air and when falling they split on 8 smaller tears")
    EID:addTrinket(RFTSTrinkets.AMBASSADORS_CROWN, "Upon entering a Treasure Rooms spawns three random pickups with space equivalents#Random Chance to turn the collectible in the room into a collectible with a space equivalent")
    EID:addTrinket(RFTSTrinkets.SKY_LIGHTS, "50% Chance upon entering a new room to petrify all enemies in the room for 4 seconds")
    EID:addTrinket(RFTSTrinkets.STAR_GAZING, "On uncleared rooms Stars falls from the sky#The stars do 80% of Isaac's damage and scale in size with Isaac's damage")

    EID:addCard(RFTSConsumables.BLESSING_FROM_THE_STARS, "Vannish the Current Floor's Curse and Grants a Blessing for the Floor#If there is no Curse: #Grants three Star Bits for Nova #Spawns Four Random Pickups for every other character")
    EID:addCard(RFTSConsumables.POCKET_8_BALL, "25% Chance of Granting two Soul Hearts #25% Chance of spawning a Random Trinket #25% Chance of rerolling a collectible into the Planetarium Pool #25% Chance of not doing anything")
    EID:addCard(RFTSConsumables.THREE_OF_SUNS, "Grants Compass effect for the floor#Grants X-Ray effect for the floor#Grants a Golden Key")
    EID:addCard(RFTSConsumables.THE_BELT, "Spawns 8 Mini Isaacs")
    EID:addCard(RFTSConsumables.THE_CONSTELLATION, "↑ {{Damage}} Grants a temporary +2.5 Damage Up # +2.5 for each Planetarium Item Isaac has")


    EID:addBirthright(RFTSCharacters.NOVA, "Higher amount of Star Bits from pickups and collectibles#Upon Entering a new floor has a chance of starting with Blessing of the Enlighted#Nova's Active petrification now last for 4 seconds on enemies")
end

return function(mod)
    mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
        if not TheFuture then return end

        TheFuture.ModdedCharacterDialogue["Nova"] = {
            "Ohhh, look at you! How Adorable!",
            "Are you looking for our leader? Have you come in peace?",
            "... Was that rude?",
            "Sorry...",
            "...",
            "You are a explorer you say?",
            "Well, I guess I do have what you are looking for then"
        } 

    end)
end
