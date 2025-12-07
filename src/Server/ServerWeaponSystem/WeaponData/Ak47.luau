--Note: Not all options are finished.
return {
	FIRERATE = 10, --Shots per second, the AK fires 600 per minute
	RANGE = 1000, --In Studs, 1000 should be good... Shouldn't be set to infinity.
	FIRE_COOLDOWN = 0.2, --time after stopped firing until you can fire gun.
	FIRETYPE = "Auto", --"Auto", "Semi", "Burst". (Burst is a bit broken...)
	BURST_SHOTS = 6,
	
	RELOAD = true, -- Reloading mechanic, if off then bullets can fire infinitely.
	BULLETS = 30, --Bullets gun can hold before needing to reload.
	MAX_BULLETS = math.huge, --Max bullets a gun could have. math.huge is infinite Bullets.
	RELOAD_TIME = 6, --Time in seconds it takes to reload gun.
	
	BODY_DAMAGE = { --This format should work for R15, R6 and other rigs.
		[Enum.Limb.Unknown] = 10, --Your base damage.
		[Enum.Limb.Head] = 30, --Head damage.
		[Enum.Limb.Torso] = 19, --Torso damage.
		[Enum.Limb.RightArm] = 13, --Right arm.
		[Enum.Limb.LeftArm] = 13, --Left arm.
		[Enum.Limb.RightLeg] = 13, --Right leg.
		[Enum.Limb.LeftLeg] = 12, --Left leg.
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
	
	--Shotgun
	--The shotgun can fire multiple bullets from a single shot.
	--There will be 2 different bullets per shot, Primary and secondary.
	--Primary bulllets are unaffected by the accuracy and will always shoot at the target. Only 1 bullet are Primary.
	--Secondary bullets are all the other bullets that get shot, they are affected by the accuracy.
	
	--Damage will be divided per bullets from the shotun. A shotgun with 4 bullets will be 25% of the damage.
	BULLETS_PER_SHOT = 5, --One of these bullets will be primary, if there is only 1 then that will be primary.
	SECONDARY_RANGE = 10, --In studs, range of the other bullets.
	
	--Laser
	LASER_SECOND_PERSISTENCE = 1, --The amount of seconds a laser persists after the shot. 
	
	--Projectiles
	
	
	--Traits - mechanics that can toggled on and off. (needs a better name)
	TRAITS = {
		EXPLOSIVE_SHOTS = false, --Landing shots will spawn an explosion.
		INSTAKILL = false, --Instantly kills on a successful shot.
		MLG = false, --If the owner character turns around a full 360 degrees then quickly fires a successful shot, it will be considered an instakill and special sound effects will play.
		SPLATTER = false, --If the shot hits a part, it will be painted with a random brickcolor.
		RANDOM_DAMAGE = false, --A gun can do 1-100 extra damage. This is a form of russian roulette.
		LIFESTEAL = false --The owner gets health based on how much damage he does.
	},
	
	ANIMATIONS = {
		Idle = "rbxassetid://139910156929242",
		Reload = "rbxassetid://111849297455299",
		Shoot = "rbxassetid://102081206061059"
	}
}