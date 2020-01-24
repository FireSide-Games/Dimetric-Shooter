extends RigidBody2D

func _ready():
	# TODO: Temporary, just to see in-game.
	self.linear_velocity = Vector2(-50, 0)
	$Sprite/AnimationPlayer.play("run")
