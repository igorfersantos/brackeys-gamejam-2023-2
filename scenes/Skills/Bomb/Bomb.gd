tool
extends Node2D

signal exploded

const RAY_CASTS = 200

var explosion_ray_scene = preload("res://scenes/Skills/Bomb/ExplosionRay.tscn")
export(int, LAYERS_2D_PHYSICS) var bomb_mask
export var bomb_strength = 1
export var bomb_radius = 40
var bomb_location = Vector2()

func init(mask, strength, radius, location):
	bomb_mask = mask
	bomb_strength = strength
	bomb_radius = radius
	bomb_location = location

func _draw():
	if !Engine.editor_hint:
		return
	draw_circle(position, bomb_radius, Color(1, 1, 1, 0.5))

func _process(delta):
	if Engine.editor_hint:
		update()
		return

func _spawn_rays():
	var i = 0
	var rotation = 0.0
	var instance = null
	while i < RAY_CASTS:
		rotation = float(i) * 360.0 / float(RAY_CASTS)
		rotation = deg2rad(rotation)
		instance = explosion_ray_scene.instance()
		instance.init(bomb_mask, Vector2(cos(rotation), sin(rotation)) * bomb_radius, bomb_location, bomb_strength)
		add_child(instance)
		i += 1

func explode():
	_spawn_rays()
	emit_signal("exploded")
