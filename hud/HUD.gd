extends CanvasLayer
class_name HUD

onready var _healthbar = $Healthbar
onready var _weapon_slot_1 = $"Weapon Slot 1"
onready var _weapon_slot_1_outline = $"Weapon Slot 1/Outline"
onready var _weapon_slot_2 = $"Weapon Slot 2"
onready var _weapon_slot_2_outline = $"Weapon Slot 2/Outline"
onready var _car_part_slot = $"Car Part Slot"

# Sets the health on the HUD (0-5 only).
func set_health(health: int) -> void:
	var frame: int = 5 - health
	self._healthbar.frame = frame

func set_weapon_1_texture(texture: Texture) -> void:
	self._weapon_slot_1_outline.texture = texture
	
func set_weapon_2_texture(texture: Texture) -> void:
	self._weapon_slot_2_outline.texture = texture

# Swaps the highlight on weapons, indicating the selected weapon.
func swap_weapon_highlight() -> void:
	var old_state_1 = self._weapon_slot_1.frame
	self._weapon_slot_1.frame = self._weapon_slot_2.frame
	self._weapon_slot_2.frame = old_state_1

# Highlights the car part slot, indicating if the player has a car part.
func highlight_car_part(highlight: bool) -> void:
	self._car_part_slot.frame = 1 if highlight else 0
