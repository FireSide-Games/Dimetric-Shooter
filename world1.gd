extends Node2D

# Internal node references
onready var navigation_map = $" bottom tiles"
onready var player = $YSort/player
onready var enemy = $YSort/irachnid


# Performed when added to scene
func _ready():
	Global.MainScene = self
	# Connects the whistle to creating a new path
	player.connect("WHISTLE", self, "_calculate_new_path")


# Calculates a new path and gives to enemy
func _calculate_new_path():

	# Finds path
	var path = navigation_map.get_astar_path(enemy.position, player.position + (enemy.position - player.position).normalized()*32)
	
	
	# If we got a path...
	if path:
		
		# Remove the first point
		path.remove(0)
		
		# Sets the enemy's path
		enemy.path = path
