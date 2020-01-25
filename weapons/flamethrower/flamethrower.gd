extends Gun

const flame_scene = preload("res://weapons/flamethrower/flame.tscn")
export var flame_speed: float = 150.0

# @param {float} seconds_since_fired 
# @returns If the gun was able to fire.
func fire(seconds_since_fired: float) -> bool:
	var can_fire: bool = .fire(seconds_since_fired)
	if can_fire:
		$AnimationPlayer.play("fire")
		$AnimationPlayer.queue("idle")
		
		var flame_instance = flame_scene.instance()
		flame_instance.rotation = self.rotation
		flame_instance.global_position = self.global_position + self.offset.rotated(self.rotation)
		var direction: Vector2 = Vector2(cos(self.rotation), sin(self.rotation))
		var velocity: Vector2 = direction * self.flame_speed
		flame_instance.linear_velocity = velocity
		Global.MainScene.add_child(flame_instance)
	return can_fire


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "fire":
		$AudioStreamPlayer2D.play()
