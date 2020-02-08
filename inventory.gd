extends Node
class_name Inventory

var _items: Array = []

func add_item(item: Item) -> void:
	self._items.append(item)

func get_items() -> Array:
	return self._items
	
func get_item(index: int) -> Item:
	return self._items[index]
	
func has_item(item: Item) -> bool:
	return self._items.find(item) != -1

func remove_item(item: Item) -> bool:
	var index: int = self._items.find(item)
	if index == -1:
		return false
	self._items.remove(index)
	return true

func item_count() -> int:
	return self._items.size()
