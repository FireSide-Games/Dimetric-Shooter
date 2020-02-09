extends Area2D
class_name Item

export var display_name: String
export var description: String
export var label_offset: Vector2 = Vector2(0, -24)

onready var tooltip = $Tooltip
onready var label = $Tooltip/Label
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var audio = $AudioStreamPlayer2D

var is_on_ground: bool = true
	
func _ready():
	# Configure tooltip object.
	var key: String = '[' + InputMap.get_action_list("pick-up")[0].as_text() + ']'
	self.label.text = self.display_name + "\n" + key
	
	var tooltip_width: int = self.label.get_global_rect().size.x
	self.tooltip.position.x = -tooltip_width / 2 * self.label.rect_scale.x
	self.tooltip.visible = false

func show_tooltip(visible: bool) -> void:
	self.tooltip.visible = visible

