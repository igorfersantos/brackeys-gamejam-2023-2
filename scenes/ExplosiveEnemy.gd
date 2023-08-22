extends "res://scenes/NormalEnemy.gd"

export var bomb_radius:int = 40
export(int, LAYERS_2D_PHYSICS) var bomb_mask


func kill():
	var deathInstance = explosiveEnemyDeathScene.instance()
	deathInstance.global_position = global_position
	deathInstance.bomb_mask = bomb_mask
	deathInstance.bomb_radius = bomb_radius
	get_parent().add_child(deathInstance)
	if (velocity.x > 0):
		deathInstance.scale = Vector2(-1, 1)

	queue_free()
