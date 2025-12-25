return {
	NAME = "M61 Vulcan",
	DESCRIPTION = [[
Brought to you by <font color="#3B73B9" family="rbxasset://fonts/families/HighwayGothic.json">General Electric</font>!
]],
	TYPE = "Rotary cannon",
	
	FIRERATE = 6000, --This is 100 times per second. God can't save you from this.
	RANGE = 9842 * .28, --9842 meters 
	FIRE_COOLDOWN = 0.2,
	FIRETYPE = "Auto",
	BURST_SHOTS = 50,
	
	SPREAD = 1.1,
	ACCURACY_MULTIPLIER = 2,
	KNOCKBACK_FORCE = 0,
	
	CARTRIDGE = "20×102mm Vulcan",
	RELOAD = true, 
	BULLETS = 1000, 
	MAX_BULLETS = 1000,
	RELOAD_TIME = 10, 
	
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