extends KinematicBody2D
class_name Player

# Constants
const SQRT_2: float = sqrt(2)
const HALF_PI: float = PI * 0.5

# Exported variables
export var speed: float = 50.0
export var max_health: float = 100
var _health: float = self.max_health

onready var _gun: Gun = $gun
var _velocity: Vector2
var _inventory: Inventory = Inventory.new()

func _ready():
	self._gun.is_on_ground = false
	self._gun.animation_player.play("idle")

func _physics_process(delta: float) -> void:
	_set_player_animation(self._velocity)
	_rotate_weapon_to_cursor()
	self._gun.update_firing_state(delta)
	move_and_slide(self._velocity)

func _unhandled_input(event: InputEvent) -> void:
	# Velocity is reset after each game tick (no drifting/acceleration)
	self._velocity = _handle_movement_input()
	
	if event.is_action_pressed("pick-up"):
		var item: Item = _get_nearby_item()
		if item != null && item.is_on_ground:
			_try_pickup_item(item)

func take_damage(damage: float) -> void:
	self._health = max(0, self._health - damage)
	if self._health <= 0:
		self.die()

# Invoked when health reaches zero.
func die() -> void:
	# TODO: Determine what happens upon death.
	print("Oh no, you died!")

func _get_nearby_item() -> Item:
	var colliding_areas: Array = $"item-intersection".get_overlapping_areas()
	colliding_areas.erase(self._gun)
	var num_colliding_areas: int = colliding_areas.size()
	if num_colliding_areas > 0:
		var area: Area2D = colliding_areas[-1]
		if area is Item:
			return area as Item
	return null

func _try_pickup_item(item: Item) -> void:
	if item is Gun:
		_try_equip_weapon(item)
	else:
		self._inventory.add_item(item)
		Global.MainScene.remove_child(item)

func _try_equip_weapon(weapon: Gun) -> void:
	# Position needs to be cached because it is changed during reparenting.
	var weapon_found_location: Vector2 = weapon.position
	
	# Swap weapon ownership (reparenting)
	self.remove_child(self._gun)
	Global.MainScene.remove_child(weapon)
	Global.MainScene.add_child(self._gun)
	self.add_child(weapon)
	
	# Update weapon states to reflect new ownership.
	var temp = self._gun
	self._gun = weapon
	self._gun.position = temp.position
	self._gun.is_on_ground = false
	self._gun.tooltip.visible = false
	self._gun.animation_player.play("idle")
	
	weapon = temp
	weapon.is_on_ground = true
	weapon.animation_player.play("float")
	weapon.sprite.rotation = 0
	weapon.sprite.scale = Vector2(1, 1)
	weapon.position = weapon_found_location
	weapon.tooltip.visible = true

func _on_area_entered(obj: Area2D):
	if obj is Item && obj.is_on_ground:
		obj.show_tooltip(true)
		
func _on_area_exited(obj: Area2D):
	if obj is Item && obj.is_on_ground:
		obj.show_tooltip(false)

func _handle_movement_input() -> Vector2:
	var vel: Vector2 = Vector2(0, 0)

	if Input.is_action_pressed("ui_left"):
		vel.x -= self.speed

	if Input.is_action_pressed("ui_right"):
		vel.x += self.speed

	if Input.is_action_pressed("ui_up"):
		vel.y -= self.speed

	if Input.is_action_pressed("ui_down"):
		vel.y += self.speed

	if vel.x == 0 || vel.y == 0:
		return vel
	else:
		# If moving at an octal direction (e.g. up AND left), scale movement to match the hypothenal speed.
		return vel / SQRT_2

func _set_player_animation(vel: Vector2) -> void:
	if vel.x == 0 && vel.y == 0:
		$body/AnimationPlayer.play("idle")
	else:
		$body/AnimationPlayer.play("run")

func _rotate_weapon_to_cursor() -> void:
	var mouse_loc: Vector2 = get_global_mouse_position()
	var angle_to_cursor: float = mouse_loc.angle_to_point(self.position + self._gun.sprite.position)
	self._gun.sprite.rotation = angle_to_cursor
	
	# Flip the gun animation if it's facing left (in radians).
	var should_flip: bool = angle_to_cursor >=  HALF_PI || angle_to_cursor < -HALF_PI
	$body.scale = Vector2(-1 if should_flip else 1, 1)
	self._gun.sprite.scale = Vector2(1, -1 if should_flip else 1)
