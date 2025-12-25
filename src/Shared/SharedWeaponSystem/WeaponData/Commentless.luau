return {
	NAME = "Commentless",
	DESCRIPTION = "... \n c h e a t e r \n ...",
	TYPE = "TEST",

	FIRERATE = 600,
	RANGE = 1000,
	FIRE_COOLDOWN = 0.2,
	FIRETYPE = "Auto",
	BURST_SHOTS = 3,
	
	SPREAD = 0.07,
	ACCURACY_MULTIPLIER = 2,
	KNOCKBACK_FORCE = 0, 

	CARTRIDGE = "",
	RELOAD = true,
	BULLETS = 30,
	MAX_BULLETS = 30,
	RELOAD_TIME = 1.78,

	BODY_DAMAGE = {
		[Enum.Limb.Unknown] = 10,
		[Enum.Limb.Head] = 15,
		[Enum.Limb.Torso] = 10,
		[Enum.Limb.RightArm] = 9,
		[Enum.Limb.LeftArm] = 9,
		[Enum.Limb.RightLeg] = 7,
		[Enum.Limb.LeftLeg] = 7,
	},

	RAYCAST_TYPE = "Ray",
	SPHERE_RAY_RADIUS = .5,
	
	GUNTYPE = "Default",

	BULLETS_PER_SHOT = 15,
	PRIMARY_RANGE = 55,
	SECONDARY_RANGE = 50,
	SHOTGUN_SPREAD = 4,

	--Laser
	LASER_SECOND_PERSISTENCE = 1,

	--RayBounce
	MAX_BOUNCES = 5,

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