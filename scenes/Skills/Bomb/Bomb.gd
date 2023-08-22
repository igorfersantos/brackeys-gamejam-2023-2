tool
extends Node2D

signal exploded

const RAY_CASTS = 200

var explosion_ray_scene = preload("res://scenes/Skills/Bomb/ExplosionRay.tscn")
export(int, LAYERS_2D_PHYSICS) var bomb_mask
export var bomb_strength = 1
export var bomb_radius = 40
var bomb_location = Vector2()

var tilemap = null
var affected_tilemap_cell_by_ray:Dictionary = {}

#debug
#var debug_hits = false
#var sucessful_rays_cast_to = []

func _ready():
	tilemap = $"/root/Helpers".get_tilemap()

# func _draw():
# 	if !Engine.editor_hint:
# 		return
	
	# to debug hits
	# for ray in sucessful_rays_cast_to:
	# 	draw_line(bomb_location, bomb_location + ray, Color.red)

	#draw_circle(position, bomb_radius, Color(1, 1, 1, 0.5))

func init(mask, strength, radius, location):
	bomb_mask = mask
	bomb_strength = strength
	bomb_radius = radius
	bomb_location = location
	#debug_hits = debug

func damage_cell(cell, tile_id):
	if tile_id == 0:
		tilemap.set_cellv(cell, 5)
	elif tile_id == 5:
		tilemap.set_cellv(cell, 4)
	elif tile_id == 4:
		tilemap.set_cellv(cell, -1)
	

func spawn_rays():
	var i = 0
	var rotation = 0.0
	var ray_instance = null
	while i < RAY_CASTS:
		rotation = float(i) * 360.0 / float(RAY_CASTS)
		rotation = deg2rad(rotation)
		ray_instance = explosion_ray_scene.instance()
		ray_instance.init(bomb_mask, Vector2(
			cos(rotation), sin(rotation)) * bomb_radius, bomb_location, bomb_strength
		)
		ray_instance.connect("ray_explosion_hit_cell", self, "on_ray_explosion_hit_cell")
		add_child(ray_instance)
		i += 1
	
	yield(ray_instance, "ray_explosion_ended")
	
func explode():
	spawn_rays()
	emit_signal("exploded")

func on_ray_explosion_hit_cell(cell, tile_id, ray):
	if tile_id == -1:
		return

	if affected_tilemap_cell_by_ray.has(cell):
		#Same cell but different raycast
		if affected_tilemap_cell_by_ray[cell]!= ray[0]:
			return

		print("cell %s with id %s will damaged by the same ray %s" % [cell, tile_id, ray])
		damage_cell(cell, tile_id)

		affected_tilemap_cell_by_ray[cell].weaken_strengh()
		return

	print("affected cell %s with id %s by ray %s" % [cell, tile_id, ray])

	damage_cell(cell, tile_id)
	affected_tilemap_cell_by_ray[cell] = (ray[0])
	affected_tilemap_cell_by_ray[cell].weaken_strengh()
