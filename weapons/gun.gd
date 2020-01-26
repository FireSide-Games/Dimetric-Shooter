extends Sprite
class_name Gun

export var projectile_scene = preload("res://weapons/bullet.tscn")
export var projectile_speed: float = 150.0
export var fire_rate: float = 1.0
export var is_automatic: bool = false

var sprite_half_width: float

func _ready():
	self.sprite_half_width = self.texture.get_size().x * self.scale.x * 0.5

# Checks if the weapon can be fired.
# @param {float} seconds_since_fired 
# @returns If the gun was able to fire.
func can_fire(seconds_since_fired: float) -> bool:
	return seconds_since_fired >= self.fire_rate

# @param {float} seconds_since_fired 
# @returns If the gun was able to fire.
func fire(seconds_since_fired: float) -> bool:
	var can_fire: bool = self.can_fire(seconds_since_fired)
	if can_fire:
		$AnimationPlayer.play("fire")
		$AnimationPlayer.queue("idle")
		_spawn_projectile()
	return can_fire

func _spawn_projectile() -> void:
	var flame_instance = projectile_scene.instance()
	flame_instance.rotation = self.rotation
	var flame_sprite: Sprite = flame_instance.get_node("Sprite")
	var flame_half_width: float = flame_sprite.texture.get_size().x / flame_sprite.hframes * 0.5
	var full_offset: Vector2 = self.offset + Vector2(self.sprite_half_width + flame_half_width, 0)
	flame_instance.global_position = self.global_position + full_offset.rotated(self.rotation)
	var direction: Vector2 = Vector2(cos(self.rotation), sin(self.rotation))
	var velocity: Vector2 = direction * self.projectile_speed
	flame_instance.linear_velocity = velocity
	Global.MainScene.add_child(flame_instance)

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "fire":
		$AudioStreamPlayer2D.play()

