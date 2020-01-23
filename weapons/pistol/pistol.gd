extends Gun

const bullet_scene = preload("res://weapons/pistol/bullet.tscn")
export var bullet_speed: float = 150.0

# @param {float} seconds_since_fired 
# @returns If the gun was able to fire.
func fire(seconds_since_fired: float) -> bool:
	var can_fire: bool = .fire(seconds_since_fired)
	if can_fire:
		$AnimationPlayer.play("fire")
		$AnimationPlayer.queue("idle")
		
		var bullet_instance = bullet_scene.instance()
		bullet_instance.rotation = self.rotation
		bullet_instance.global_position = self.global_position + self.offset.rotated(self.rotation)
		var direction: Vector2 = Vector2(cos(self.rotation), sin(self.rotation))
		var velocity: Vector2 = direction * self.bullet_speed
		bullet_instance.linear_velocity = velocity
		Global.MainScene.add_child(bullet_instance)
	return can_fire


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "fire":
		$AudioStreamPlayer2D.play()
