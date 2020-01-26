extends Gun

export var flame_offset: float = 0.0

# TODO: Make system to turn on/off fire, and sound effect

func _process(delta):
	if self.is_auto_firing:
		self._set_flame_position()

# Checks if the weapon can be fired.
# @param {float} seconds_since_fired 
# @returns If the gun was able to fire.
func can_fire(seconds_since_fired: float) -> bool:
	# TODO: Have this check an overheat variable.
	return true

func _spawn_projectile() -> void:
	$Particles2D.emitting = true
	
func stop_firing() -> void:
	.stop_firing()
	$Particles2D.emitting = false

func _set_flame_position() -> void:
	var full_offset: Vector2 = self.offset + Vector2(self.sprite_half_width, 0)
	$Particles2D.global_position = self.global_position + full_offset.rotated(self.rotation)