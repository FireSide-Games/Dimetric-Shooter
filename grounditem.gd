extends Area2D
class_name GroundItem

export var display_name: String
export var label_offset: Vector2 = Vector2(0, -24)

var tooltip = preload("res://Tooltip.tscn").instance()
var label = self.tooltip.get_node("Label")

func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	self.connect("body_exited", self, "_on_body_exited")
	
	# Configure tooltip object.
	self.add_child(self.tooltip)
	var tooltip_size: Vector2 = self.label.get_global_rect().size
	var rect_scale: Vector2 = self.label.rect_scale
	var center: Vector2 = Vector2(-tooltip_size.x / 2 * rect_scale.x,
								  -tooltip_size.y / 2 * rect_scale.y)
	center += self.label_offset
	self.tooltip.position = center
	
	var key: String = '[' + InputMap.get_action_list("pick-up")[0].as_text() + ']'
	self.label.text = self.display_name + "\n" + key
	self.tooltip.visible = false

func _on_body_entered(body: PhysicsBody2D):
	if body is Player:
		self.tooltip.visible = true
		
func _on_body_exited(body: PhysicsBody2D):
	if body is Player:
		self.tooltip.visible = false