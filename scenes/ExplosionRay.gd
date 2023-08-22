extends RayCast2D

var strength = 3
var collider = null
var tilemap
var cell = Vector2()
var tile_id = -1

var initialized = false


func _ready():
	tilemap = get_tree().get_nodes_in_group("base_level")[0].get_node("TileMap")
	$ExplosionTimer.connect("timeout", self, "on_explosion_timer_timeout")


func init(cast, global_pos):
	cast_to = cast
	position = global_pos
	initialized = true


func _physics_process(delta):
	collider = get_collider()
	
	if (!initialized or collider == null):
		return
	
	if (collider.is_in_group("enemy")):
		# do enemy logic here
		set_collision_mask_bit(0, false)
		return
	
	#if (collider.is_in_group("player")):
		# same thing as in enemy but for player
		#return

	if (collider.name == "TileMap"):
		cell = tilemap.world_to_map(get_collision_point() - get_collision_normal())
#		tile_id = tilemap.get_cellv(cell)
#		if tile_id == 2:
#			tilemap.set_cellv(cell, 3)
#		elif tile_id == 3:
#			tilemap.set_cellv(cell, 4)
#		elif tile_id == 4:
#			tilemap.set_cellv(cell, -1)
		tilemap.set_cellv(cell, -1)
		
	strength -= 1
	if strength <= 0:
		queue_free()


func on_explosion_timer_timeout():
	queue_free()
