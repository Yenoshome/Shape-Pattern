extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	update_high_score()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func update_high_score():
	$HighScoreContainer/HighScoreValue.text = str(GlobalData.high_score)
