extends Sprite
class_name Gun

# Exported variables
export var projectile_scene = preload("res://weapons/bullet.tscn")
export var projectile_speed: float = 150.0
export var fire_rate: float = 1.0
export var is_automatic: bool = false
export var queue_fire_threshold: float = 0.2

var time_since_fired: float = 0.0
var queued_shot: bool = false
var sprite_half_width: float
var is_auto_firing: bool = false

func _ready():
	self.sprite_half_width = self.texture.get_size().x * self.scale.x * 0.5 / self.hframes

func _physics_process(delta: float) -> void:
	update_firing_state(delta)

func update_firing_state(delta: float) -> void:
	self.time_since_fired += delta
	# If we try to fire before we are able to, but it is within a certain threshold (queue_fire_threshold),
	# we will queue up the shot to be fired as soon as the gun allows.
	if queued_shot || self.is_automatic && Input.is_action_pressed("fire") || Input.is_action_just_pressed("fire"):
		if try_fire():
			queued_shot = false
		elif self.fire_rate - self.time_since_fired <= self.queue_fire_threshold:
			queued_shot = true
	elif self.is_automatic && self.is_auto_firing && Input.is_action_just_released("fire"):
		self.stop_firing()

# @returns If the gun fired.
func try_fire() -> bool:
	return self.fire(self.time_since_fired)

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
		self.time_since_fired = 0.0
		self.is_auto_firing = self.is_automatic
		$AnimationPlayer.play("fire")
		$AnimationPlayer.queue("idle")
		_spawn_projectile()
	return can_fire

func stop_firing() -> void:
	self.is_auto_firing = false

func _spawn_projectile() -> void:
	var projectile_instance = projectile_scene.instance()
	projectile_instance.rotation = self.rotation
	var projectile_sprite: Sprite = projectile_instance.get_node("Sprite")
	var projectile_sprite_half_width: float = projectile_sprite.texture.get_size().x / projectile_sprite.hframes * 0.5
	var full_offset: Vector2 = self.offset + Vector2(self.sprite_half_width + projectile_sprite_half_width, 0)
	projectile_instance.global_position = self.global_position + full_offset.rotated(self.rotation)
	var direction: Vector2 = Vector2(cos(self.rotation), sin(self.rotation))
	var velocity: Vector2 = direction * self.projectile_speed
	projectile_instance.linear_velocity = velocity
	Global.MainScene.add_child(projectile_instance)

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "fire":
		$AudioStreamPlayer2D.play()

