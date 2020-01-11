extends Gun

# Attempts to fire the gun.
# @param {float} seconds_since_fired 
# @returns If the gun was able to fire.
func fire(seconds_since_fired: float) -> bool:
	var can_fire: bool = .fire(seconds_since_fired)
	if can_fire:
		# TODO: This should be handled by an AnimationTree in the future.
		$AnimationPlayer.play("fire")
		$AnimationPlayer.queue("idle")
	return can_fire
