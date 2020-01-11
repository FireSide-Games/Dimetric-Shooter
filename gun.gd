extends Sprite
class_name Gun

export var fire_rate: float = 1.0

# Attempts to fire the gun.
# @param {float} seconds_since_fired 
# @returns If the gun was able to fire.
func fire(seconds_since_fired: float) -> bool:
	return seconds_since_fired >= self.fire_rate
