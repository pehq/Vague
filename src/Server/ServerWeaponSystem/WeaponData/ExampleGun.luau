--Note: Not all options are finished.
return {
	FIRERATE = 15, --Shots per second
	RANGE = 1000, --In Studs, 1000 should be good... Shouldn't be set to infinity.
	FIRE_COOLDOWN = 0.2, --time after stopped firing until you can fire gun.
	FIRETYPE = "Auto", --"Auto", "Semi". (I don't wanna add burst because it's cancerous.)
	
	RELOAD = false, -- Reloading mechanic, if off then bullets can fire infinitely.
	BULLETS = 30, --Bullets gun can hold before needing to reload.
	MAX_BULLETS = math.huge, --Max bullets a gun could have. math.huge is infinite Bullets.
	RELOAD_TIME = 1, --Time in seconds it takes to reload gun.
	
	BODY_DAMAGE = { --This format should work for R15, R6 and other rigs.
		[Enum.Limb.Unknown] = 3, --Your base damage.
		[Enum.Limb.Head] = 5, --Head damage.
		[Enum.Limb.Torso] = 4, --Torso damage.
		[Enum.Limb.RightArm] = 2, --Right arm.
		[Enum.Limb.LeftArm] = 2, --Left arm.
		[Enum.Limb.RightLeg] = 1, --Right leg.
		[Enum.Limb.LeftLeg] = 1, --Left leg.
	},
	
	--"Ray" is a simple line that's drawn from the start to target.
	--"Sphere" Same as before but it'll check if something is being collided with a 3d sphere. This makes aiming much more easier but tends to be more proccessing at high firerates (like around 240 per second.)
	RAYCAST_TYPE = "Ray",
	
	--Gun types have their own code but will try to work with the value they are provided.
	--"Default" Fires a single shot every trigger.
	--"Shotgun" Fires multiple shots in a spread-like manner.
	--"Laser" Fires a continous laser.
	--"Projectile" Fires a projectile that is rendered on the clients but is computated on server.
	GUNTYPE = "Default",
	
	--Traits - mechanics that can toggled on and off. (needs a better name)
	TRAITS = {
		EXPLOSIVE_SHOTS = false, --Landing shots will spawn an explosion.
		INSTAKILL = false, --Instantly kills on a successful shot.
		MLG = false, --If the owner character turns around a full 360 degrees then quickly fires a successful shot, it will be considered an instakill and special sound effects will play.
		SPLATTER = false, --If the shot hits a part, it will be painted with a random brickcolor.
		RANDOM_DAMAGE = false, --A gun can do 1-100 extra damage. This is a form of russian roulette.
		LIFESTEAL = false --The owner gets health based on how much damage he does.
	}
}