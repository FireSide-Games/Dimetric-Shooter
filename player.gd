extends KinematicBody2D

# Signal the sidekick should come to the player
signal WHISTLE

# Constants
const SQRT_2: float = sqrt(2)
const HALF_PI: float = PI * 0.5

# Exported variables
export var speed: float = 50.0

func _physics_process(delta: float) -> void:
	# Velocity is reset after each game tick (no drifting/acceleration)
	var velocity: Vector2 = handle_movement_input()
	set_player_animation(velocity)
	rotate_weapon_to_cursor()
	# move_and_slide automatically multiplies velocity by `delta`.
	move_and_slide(velocity)
	
	# If pressing space, whistle
	if Input.is_action_just_pressed("ui_accept"):
		emit_signal("WHISTLE")

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
	#$body.flip_h = should_flip
	$body.scale = Vector2(-1 if should_flip else 1, 1)
	$gun.scale = Vector2(1, -1 if should_flip else 1)
