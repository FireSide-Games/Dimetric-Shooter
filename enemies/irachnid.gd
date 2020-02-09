extends RigidBody2D

export var max_health: float = 100
var health = self.max_health

func _ready():
	# TODO: Temporary, just to see in-game.
	self.linear_velocity = Vector2(-50, 0)
	$Sprite/AnimationPlayer.play("run")

# Removes health equivalent to the given damage.
func take_damage(damage: float) -> void:
	self.health = max(0, self.health - damage)
	if self.health <= 0:
		self.die()

# Invoked when health reaches zero.
func die() -> void:
	print("Oh no, you died!")

