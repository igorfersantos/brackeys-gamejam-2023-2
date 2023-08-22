extends Node2D

var bomb_scene = preload("res://scenes/ExplosionRay.tscn")

export var flip_blood = false
const RAY_CASTS = 200

var bomb_mask = null
var bomb_radius = 40

func init(mask, radius):
	bomb_mask = mask
	bomb_radius = radius

func _ready():
	$DeathSoundPlayer1.play()
	$DeathSoundPlayer2.play()
	
	var material: ParticlesMaterial = $Particles2D_Explosion.process_material
	
	if (flip_blood):
		material.direction.x = material.direction.x *-1

func spawn_bomb():
	var i = 0
	var rotation = 0.0
	var instance = null
	while i < RAY_CASTS:
		rotation = float(i) * 360.0 / float(RAY_CASTS)
		rotation = deg2rad(rotation)
		instance = bomb_scene.instance()
		instance.init(bomb_mask, Vector2(cos(rotation), sin(rotation)) * bomb_radius, position)
		get_parent().add_child(instance)
		i += 1
