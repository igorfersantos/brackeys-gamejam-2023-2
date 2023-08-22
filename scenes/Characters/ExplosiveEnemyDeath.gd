extends Node2D

signal bomb_dropped

export var flip_blood = false

func _ready():
	$DeathSoundPlayer1.play()
	$DeathSoundPlayer2.play()
	
	var material: ParticlesMaterial = $Particles2D_Explosion.process_material
	
	if (flip_blood):
		material.direction.x = material.direction.x *-1

func drop_bomb():
	emit_signal("bomb_dropped")
