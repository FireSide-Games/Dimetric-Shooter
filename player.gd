extends KinematicBody2D

# Constants
const SQRT_2: float = sqrt(2)
const HALF_PI: float = PI * 0.5

# Exported variables
export var speed: float = 50.0
var time_since_fired: float = 0.0

func _physics_process(delta: float) -> void:
	# Velocity is reset after each game tick (no drifting/acceleration)
	var velocity: Vector2 = handle_movement_input()
	
	self.time_since_fired += delta
	# TODO: Hard-coded as semi-auto. Make a weapon interface with "is_automatic" property.
	if Input.is_action_just_pressed("fire"):
		try_fire(delta)
	
	set_player_animation(velocity)
	
	rotate_weapon_to_cursor()
	
	# move_and_slide automatically multiplies velocity by `delta`.
	move_and_slide(velocity)

func handle_movement_input() -> Vector2:
	var velocity: Vector2 = Vector2(0, 0)

	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

	if Input.is_action_pressed("ui_right"):
		velocity.x += speed

	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed

	if Input.is_action_pressed("ui_down"):
		velocity.y += speed

	if velocity.x == 0 || velocity.y == 0:
		return velocity
	else:
		# If moving at an octal direction (e.g. up AND left), scale movement to match the hypothenal speed.
		return velocity / SQRT_2

func try_fire(delta: float) -> void:
	if $pistol.fire(self.time_since_fired):
		self.time_since_fired = 0.0

func set_player_animation(velocity: Vector2) -> void:
	if velocity.x == 0 && velocity.y == 0:
		$body/AnimationPlayer.play("idle")
	else:
		$body/AnimationPlayer.play("run")

func rotate_weapon_to_cursor() -> void:
	var mouse_loc: Vector2 = get_global_mouse_position()
	var angle_to_cursor: float = mouse_loc.angle_to_point(self.position)
	$pistol.rotation = angle_to_cursor
	
	# Flip the gun animation if it's facing left (in radians).
	var should_flip: bool = angle_to_cursor >=  HALF_PI || angle_to_cursor < -HALF_PI
	#$body.flip_h = should_flip
	$body.scale = Vector2(-1 if should_flip else 1, 1)
	$pistol.scale = Vector2(1, -1 if should_flip else 1)
