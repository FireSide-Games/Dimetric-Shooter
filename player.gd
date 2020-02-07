extends KinematicBody2D
class_name Player

# Constants
const SQRT_2: float = sqrt(2)
const HALF_PI: float = PI * 0.5

# Exported variables
export var speed: float = 50.0

var velocity: Vector2

func _unhandled_input(event: InputEvent) -> void:
	# Velocity is reset after each game tick (no drifting/acceleration)
	self.velocity = handle_movement_input()
	
	if event.is_action_pressed("pick-up"):
		var item: GroundItem = _get_nearby_item()
		if item != null:
			_try_pickup_item(item)

func _get_nearby_item() -> GroundItem:
	var colliding_areas: Array = $"grounditem-intersection".get_overlapping_areas()
	var num_colliding_areas: int = colliding_areas.size()
	if num_colliding_areas > 0:
		var area: Area2D = colliding_areas[num_colliding_areas - 1]
		if area is GroundItem:
			return area as GroundItem
	return null

func _try_pickup_item(item: GroundItem) -> void:
	print("trying to pick up - it's so heavy!")

func _on_area_entered(obj: Area2D):
	if obj is GroundItem:
		obj.show_tooltip(true)
		
func _on_area_exited(obj: Area2D):
	if obj is GroundItem:
		obj.show_tooltip(false)

func _physics_process(delta: float) -> void:
	set_player_animation(self.velocity)
	rotate_weapon_to_cursor()
	move_and_slide(self.velocity)

func handle_movement_input() -> Vector2:
	var velocity: Vector2 = Vector2(0, 0)

	if Input.is_action_pressed("ui_left"):
		velocity.x -= self.speed

	if Input.is_action_pressed("ui_right"):
		velocity.x += self.speed

	if Input.is_action_pressed("ui_up"):
		velocity.y -= self.speed

	if Input.is_action_pressed("ui_down"):
		velocity.y += self.speed

	if velocity.x == 0 || velocity.y == 0:
		return velocity
	else:
		# If moving at an octal direction (e.g. up AND left), scale movement to match the hypothenal speed.
		return velocity / SQRT_2

func set_player_animation(velocity: Vector2) -> void:
	if velocity.x == 0 && velocity.y == 0:
		$body/AnimationPlayer.play("idle")
	else:
		$body/AnimationPlayer.play("run")

func rotate_weapon_to_cursor() -> void:
	var mouse_loc: Vector2 = get_global_mouse_position()
	var angle_to_cursor: float = mouse_loc.angle_to_point(self.position + $gun.position)
	$gun.rotation = angle_to_cursor
	
	# Flip the gun animation if it's facing left (in radians).
	var should_flip: bool = angle_to_cursor >=  HALF_PI || angle_to_cursor < -HALF_PI
	$body.scale = Vector2(-1 if should_flip else 1, 1)
	$gun.scale = Vector2(1, -1 if should_flip else 1)
