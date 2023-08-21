extends Node2D

export var flip_blood = false

func _ready():
	$DeathSoundPlayer1.play()
	$DeathSoundPlayer2.play()
	
	var material: ParticlesMaterial = $Particles2D_Blood.process_material
	
	if (flip_blood):
		material.direction.x = material.direction.x *-1
