extends CanvasLayer

func _ready():
	#$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/NextLevelButton.connect("pressed", self, "on_next_button_pressed")
	$MarginContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer2/RestartButton.connect("pressed", self, "on_restart_button_pressed")

func on_next_button_pressed():
	$"/root/LevelManager".change_to_next_level()

func on_restart_button_pressed():
	$"/root/LevelManager".restart_level()
