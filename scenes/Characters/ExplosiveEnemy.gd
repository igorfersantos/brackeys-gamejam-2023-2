extends KinematicBody2D

signal dead

enum Direction { RIGHT, LEFT }

export(Direction) var startDirection

var explosiveEnemyDeathScene = preload("res://scenes/Characters/ExplosiveEnemyDeath.tscn")

var isSpawning = true
var maxSpeed = 25
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

var bomb_scene = preload("res://scenes/Skills/Bomb/Bomb.tscn")
export var bomb_strength:int = 1
export var bomb_radius:int = 40
export(int, LAYERS_2D_PHYSICS) var bomb_mask

func _ready():
	# Note that this will be overwritten in EnemySpawners!
	direction = startDirection
	
	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")

	$ExplosionTimer.connect("timeout", self, "on_explosion_timer_timeout")

func _process(delta):
	$Visuals/AnimatedSprite.flip_h = velocity.x > 0 || direction.x > 0
	
	if (isSpawning):
		return
	
	velocity.x = (direction * maxSpeed).x
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)


func kill():
	var deathInstance = explosiveEnemyDeathScene.instance()
	deathInstance.global_position = global_position
	get_parent().add_child(deathInstance)
	if (velocity.x > 0 || direction.x > 0):
		deathInstance.scale = Vector2(-1, 1)
	
	set_process(false)
	set_physics_process(false)
	$Visuals.visible = false
	$CollisionShape2D.disabled = true
	$GoalDetector.monitorable = false
	$HazardArea.monitorable = false
	$HitboxArea.monitorable = false
	
	emit_signal("dead")
	
	yield(deathInstance, "bomb_dropped")
	
	var bomb = bomb_scene.instance()
	get_parent().add_child(bomb)
	bomb.init(bomb_mask, bomb_strength, bomb_radius, position)
	bomb.explode()
	
	queue_free()

func on_goal_entered(_area2d):
	direction *= -1;

func on_hitbox_entered(_area2d):
	$"/root/Helpers".apply_camera_snake(1)
	call_deferred("kill")
	
func on_explosion_timer_timeout():
	kill()
