extends KinematicBody2D

enum Direction { RIGHT, LEFT }

export(Direction) var startDirection

var enemyDeathScene = preload("res://scenes/EnemyDeath.tscn")

export var isSpawning = true
var maxSpeed = 25
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var gravity = 500

func _ready():
	direction = get_start_direction()
	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")

func get_start_direction():
	return Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT

func _process(delta):
	if (isSpawning):
		return
	
	velocity.x = (direction * maxSpeed).x
	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

	$Visuals/AnimatedSprite.flip_h = direction.x > 0

func kill():
	var deathInstance = enemyDeathScene.instance()
	get_parent().add_child(deathInstance)
	deathInstance.global_position = global_position
	if (velocity.x > 0):
		deathInstance.scale = Vector2(-1, 1)

	queue_free()

func on_goal_entered(_area2d):
	direction *= -1;

func on_hitbox_entered(_area2d):
	$"/root/Helpers".apply_camera_snake(1)
	call_deferred("kill")
