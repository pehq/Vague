return {
	NAME = "FN FAL",
	DESCRIPTION = "Example Gun Of Testing Instances, Situationally Murky",
	TYPE = "Battle rifle",
	
	FIRERATE = 120,
	RANGE = 435, 
	FIRE_COOLDOWN = 0.1,
	FIRETYPE = "Semi",
	BURST_SHOTS = 3,
	
	SPREAD = math.deg(math.atan(0.1/(175 * 0.28))),
	ACCURACY_MULTIPLIER = 2,
	KNOCKBACK_FORCE = 0,
	
	CARTRIDGE = "7.63×25mm Mauser",
	RELOAD = true, 
	BULLETS = 10, 
	MAX_BULLETS = 10,
	RELOAD_TIME = 1.78, 
	
	BODY_DAMAGE = { 
		[Enum.Limb.Unknown] = 10, 
		[Enum.Limb.Head] = 35, 
		[Enum.Limb.Torso] = 13, 
		[Enum.Limb.RightArm] = 12, 
		[Enum.Limb.LeftArm] = 11, 
		[Enum.Limb.RightLeg] = 8, 
		[Enum.Limb.LeftLeg] = 8, 
	},
	
	RAYCAST_TYPE = "Ray",
	SPHERE_RAY_RADIUS = .5,
	
	GUNTYPE = "Default",
	
	BULLETS_PER_SHOT = 15, 
	PRIMARY_RANGE = 55,
	SECONDARY_RANGE = 50, 
	SHOTGUN_SPREAD = 4,
	
	LASER_SECOND_PERSISTENCE = 1, 
	
	LIFE_TIME = 10, 
	MAX_PROJECTILE = 1000, 
	PROJECTILE_RADIUS = 1, 
	PROJECTILE_SPEED = 600, 
	PROJECTILE_LAUNCH_POWER = 1, 
	
	PP_TYPE = "Bouncing", 
	PP_TIMESCALE = 1, 
	PP_GRAVITY_ENABLED = false,
	PP_GRAVITY_FORCE = 1,
	PP_REFLECT_ENABLED = false,
	
	
	TRAITS = {
		EXPLOSIVE_SHOTS = false, 
		INSTAKILL = false, 
		MLG = false, 
		SPLATTER = false, 
		RANDOM_DAMAGE = false, 
		LIFESTEAL = false 
	},
	
	ANIMATIONS = {
		Idle = "rbxassetid://139910156929242",
		Reload = "rbxassetid://111849297455299",
		Shoot = "rbxassetid://102081206061059"
	}
}