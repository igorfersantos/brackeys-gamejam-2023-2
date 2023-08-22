extends KinematicBody2D

signal dead

enum Direction { RIGHT, LEFT }

export(Direction) var startDirection

var explosiveEnemyDeathScene = preload("res://scenes/ExplosiveEnemyDeath.tscn")

export var isSpawning = true
var maxSpeed = 25
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

func _ready():
	# Note that this will be overwritten in EnemySpawners!
	direction = startDirection
	
	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")

func _process(delta):
	if (isSpawning):
		return
	
	velocity.x = (direction * maxSpeed).x
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

	$Visuals/AnimatedSprite.flip_h = direction.x > 0


func kill():
	var deathInstance = explosiveEnemyDeathScene.instance()
	get_parent().add_child(deathInstance)
	deathInstance.global_position = global_position
	if (velocity.x > 0 || direction.x > 0):
		deathInstance.scale = Vector2(-1, 1)
	
	emit_signal("dead")
	queue_free()

func on_goal_entered(_area2d):
	direction *= -1;

func on_hitbox_entered(_area2d):
	$"/root/Helpers".apply_camera_snake(1)
	call_deferred("kill")
