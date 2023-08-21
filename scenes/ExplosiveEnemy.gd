extends "res://scenes/NormalEnemy.gd"

const RADIUS = 40
const RAY_CASTS = 200

var explosion_ray = preload("res://scenes/ExplosionRay.tscn")

func _ready():
	#set_process(false)
	$ExplodeTimer.connect("timeout", self, "on_explode_timer_timeout")

func spawn_rays():
	var i = 0
	var rotation = 0.0
	var instance = null
	while i < RAY_CASTS:
		rotation = float(i) * 360.0 / float(RAY_CASTS)
		rotation = deg2rad(rotation)
		instance = explosion_ray.instance()
		instance.init(Vector2(cos(rotation), sin(rotation)) * RADIUS, position)
		get_parent().add_child(instance)
		i += 1

func explode():
	spawn_rays()
	queue_free()

func on_explode_timer_timeout():
	explode()
