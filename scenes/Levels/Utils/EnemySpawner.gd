extends Position2D

enum Direction { RIGHT, LEFT }

export(Direction) var startDirection
export(PackedScene) var enemyScene
export(Resource) var enemy_stats;

var currentEnemyNode = null
var spawnOnNextTick = false

func _ready():
	$SpawnTimer.connect("timeout", self, "on_check_enemy_spawn")
	call_deferred("spawn_enemy")

func get_start_direction():
	return Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT

func spawn_enemy():
	currentEnemyNode = enemyScene.instance()
	if enemy_stats:
		currentEnemyNode.stats = enemy_stats
	currentEnemyNode.stats.startDirection = get_start_direction()
	currentEnemyNode.global_position = global_position
	get_parent().add_child(currentEnemyNode)

func check_enemy_spawn():
	if is_instance_valid(currentEnemyNode): 
		return
		
	if (spawnOnNextTick):
		spawn_enemy()
		spawnOnNextTick = false
	else: 
		spawnOnNextTick = true

func on_check_enemy_spawn():
	check_enemy_spawn()
