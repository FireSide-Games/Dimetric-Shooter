extends RigidBody2D

# Exported variables
export var speed: float = 50.0
export var curve_radius: float  = 5

# astar generated path enemy follows (passed in by world)
var path


# Performed on each step
func _physics_process(delta):

	if path:

		# The next point is the first member of the path array
		var target = path[0]
		var direction = (target -  position).normalized()
		print(position)
		# Move direction to next path point
		position += direction * speed * delta
		$Sprite/AnimationPlayer.play("run")
		

		# 
		if position.distance_to(target) < curve_radius:

			# Remove first path point
			path.remove(0)

			# If we have no points left, remove path
			if path.size() == 0:
				path = null
	else:
		$Sprite/AnimationPlayer.play("idle")
