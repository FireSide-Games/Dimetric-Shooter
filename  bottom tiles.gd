extends TileMap


onready var astar = AStar2D.new()

# Used to find the centre of a tile
onready var half_cell_size = cell_size / 2

# All tiles that can be used for pathfinding
onready var traversable_tiles = [];

# The bounds of the rectangle containing all used tiles on this tilemap
onready var used_rect = get_used_rect()


func _ready():

	traversable_tiles = _get_traversable_tiles()
	# Add all tiles to the navigation grid
	_add_traversable_tiles(traversable_tiles)

	# Connects all added tiles
	_connect_traversable_tiles(traversable_tiles)


## Private functions

func _get_traversable_tiles():
	var traversable_tiles = []
	var shapes_at_point = []
	for tile in get_used_cells():
		shapes_at_point = get_world_2d().direct_space_state.intersect_point(map_to_world(tile), 5, [] , 0x00000002)
		if shapes_at_point.size() > 0:
			traversable_tiles.append(tile)
	print(traversable_tiles)
	return traversable_tiles

# Adds tiles to the A* grid but does not connect them
# ie. They will exist on the grid, but you cannot find a path yet
func _add_traversable_tiles(traversable_tiles):

	# Loop over all tiles
	for tile in traversable_tiles:
		# Determine the ID of the tile
		var id = _get_id_for_point(tile)

		astar.add_point(id, tile)


# Connects all tiles on the A* grid with their surrounding tiles
func _connect_traversable_tiles(traversable_tiles):
 
	# Loop over all tiles
	for tile in traversable_tiles:

		# Determine the ID of the tile
		var id = _get_id_for_point(tile)

		# Loops used to search around player (range(3) returns 0, 1, and 2)
		for x in range(3):
			for y in range(3):

				# Determines target, converting range variable to -1, 0, and 1
				var target = tile + Vector2(x - 1, y - 1)

				# Determines target ID
				var target_id = _get_id_for_point(target)

				# Do not connect if point is same or point does not exist on astar
				if tile == target or not astar.has_point(target_id):
					continue

				# Connect points
				astar.connect_points(id, target_id, true)


# Determines a unique ID for a given point on the map
func _get_id_for_point(point):

	# Offset position of tile with the bounds of the tilemap
	# This prevents ID's of less than 0, if points are behind (0, 0)
	var x = point.x - used_rect.position.x
	var y = point.y - used_rect.position.y

	# Returns the unique ID for the point on the map
	return x + y * used_rect.size.x


## Public functions

# Returns a path from start to end
# These are real positions, not cell coordinates
func get_astar_path(start, end):

	# Convert positions to cell coordinates
	var start_tile = world_to_map(start)
	var end_tile = world_to_map(end)

	# Determines IDs
	var start_id = _get_id_for_point(start_tile)
	var end_id = _get_id_for_point(end_tile)

	# Return null if navigation is impossible
	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return null
		
	var path_map = astar.get_point_path(start_id, end_id)
	
	print("Enemy Pos")
	print(start_tile)
	print("Player Pos")	
	print(end_tile)
	var world_path_map = []
	for index in range(1, len(path_map)):
		world_path_map.append(map_to_world(path_map[index]))
	return world_path_map
