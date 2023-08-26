extends Node2D

signal bomb_dropped


func _ready():
	$DeathSoundPlayer1.play()
# 	$DeathSoundPlayer2.play()

func drop_bomb():
	emit_signal("bomb_dropped")
