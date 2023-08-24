extends Node


func _ready():
	if OS.has_feature("editor"):
		OS.window_fullscreen = false