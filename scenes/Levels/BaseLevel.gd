extends Node

signal coin_total_changed(total_coins, collectedCoins)

export(PackedScene) var playerScene
export(PackedScene) var levelCompleteScene 

var pauseScene = preload("res://scenes/UI/PauseMenu.tscn")
var spawnPosition = Vector2.ZERO
var current_player_node = null
var total_coins = 0
var collected_coins = 0

func _ready():
	spawnPosition = $PlayerSpawnPoint.global_position
	var player_instance = register_player(playerScene)
	spawn_player(player_instance)
	coin_total_changed(get_tree().get_nodes_in_group("coin").size())

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		var pauseInstance = pauseScene.instance()
		add_child(pauseInstance)

func coin_collected():
	collected_coins += 1
	print(total_coins, " - ", collected_coins)
	emit_signal("coin_total_changed", total_coins, collected_coins)


func coin_total_changed(newTotal):
	total_coins = newTotal
	emit_signal("coin_total_changed", total_coins, collected_coins)


func register_player(player_scene):
	current_player_node = player_scene.instance()
	current_player_node.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)
	return current_player_node

func spawn_player(player_instance):
	$PlayerSpawnPoint.add_child(player_instance)
	player_instance.global_position = $PlayerSpawnPoint.global_position

func on_player_died():
	current_player_node.queue_free()

	var timer = get_tree().create_timer(1.5)
	yield(timer, "timeout")

	var new_player_instance = register_player(playerScene)
	spawn_player(new_player_instance)

func on_player_won():
	current_player_node.disable_player_input()
	var levelComplete = levelCompleteScene.instance()
	add_child(levelComplete)
