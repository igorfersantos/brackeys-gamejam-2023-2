extends Node

func apply_camera_snake(percetage):
	var cameras = get_tree().get_nodes_in_group("camera")

	if (cameras.size() > 0):
		cameras[0].apply_shake(percetage)
