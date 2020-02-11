extends Node2D

func _ready():
	Global.MainScene = $YSort
	Global.HUD = preload("res://hud/HUD.tscn").instance()
	Global.HUD.scale = Vector2(4, 4)
	Global.HUD.offset = Vector2(10, 10)
	Global.MainScene.add_child(Global.HUD)
