extends Node2D

# VARIABLES
@export var shapes : Array[Texture2D] = []
var shape_sequence = []
var player_sequence = []
var is_waiting_for_input = false
var current_index = 0
var is_displaying_sequence = true
var score = 0
var lives = 3
var consec_wins = 0
var loss_count = 0
var base_speed = 1.0
var min_speed = 0.2

# FUNCTIONS
func _ready():
	randomize()
	generate_sequence()
	update_lives_display()
	is_displaying_sequence = true
	current_index = 0
	display_next_shape()
	
func generate_sequence():
	var base_length = 3
	var sequence_length = base_length + consec_wins
	sequence_length = max(sequence_length, 3)
	
	var shuffled_shapes = shapes.duplicate()
	shuffled_shapes.shuffle()
	
	shape_sequence.clear()
	
	for i in range(sequence_length):
		var new_shape = shuffled_shapes[randi() % shuffled_shapes.size()]
		while shape_sequence.size() > 0 and shape_sequence[shape_sequence.size() - 1] == new_shape:
			new_shape = shuffled_shapes[randi() % shuffled_shapes.size()]
		shape_sequence.append(new_shape)
	
	adjust_speed()
	
	
func reset_game():
	player_sequence.clear()
	current_index = 0
	is_waiting_for_input = false
	is_displaying_sequence = true
	generate_sequence()
	display_next_shape()

func adjust_speed():
	var speed_changer = max(min_speed, base_speed * pow(0.8, floor(consec_wins)))
	$SequenceTimer.wait_time = speed_changer
	print ("Current Speed: ", speed_changer)

func check_player_sequence():
	if player_sequence.size() == shape_sequence.size():
		if player_sequence == shape_sequence:
			show_graphic("win")
			consec_wins += 1
			increase_score()
		else:
			show_graphic("lose")
			decrease_lives()
		$ResetTimer.start()	
	
	
		
func check_loss_streak():
	loss_count += 1
	if loss_count >= 3:
		reset_consec_wins()
		game_over()
	else:
		reset_game()
		
		
		
func reset_consec_wins():
	consec_wins = 0	
	$SequenceTimer.wait_time = base_speed
	
	
	
func display_next_shape():
	if current_index < shape_sequence.size():
		$GameUI/BigBox.texture = shape_sequence[current_index]
		current_index += 1
		$SequenceTimer.start()
	else:
		is_displaying_sequence = false
		is_waiting_for_input = true



func _on_sequence_timer_timeout():
	display_next_shape()
	
	
	
func update_lives_display():
	$GameUI/LivesLayer/LivesContainer/LivesValue.text = str(lives)	
	
	
	
func show_graphic(outcome: String):
	$WinLoseUI/WinGraphic.visible = outcome == "win"
	$WinLoseUI/LoseGraphic.visible = outcome == "lose"
	
	
	
func increase_score():
	score += 1
	$GameUI/ScoreContainer/ScoreValue.text = str(score)
	
	if score > GlobalData.high_score:
		GlobalData.high_score = score
	
func decrease_lives():
	lives -= 1
	update_lives_display()
	if lives <= 0:
		game_over()

func game_over():
	print("Game Over")
	lives = 3
	score = 0
	consec_wins = 0
	update_lives_display()
	$GameUI/ScoreContainer/ScoreValue.text = str(score)
	reset_game()

func _on_triangle_button_pressed():
	if is_waiting_for_input:
		player_sequence.append(shapes[0])
		check_player_sequence()

func _on_circle_button_pressed():
	if is_waiting_for_input:
		player_sequence.append(shapes[1])
		check_player_sequence()

func _on_square_button_pressed():
	if is_waiting_for_input:
		player_sequence.append(shapes[2])
		check_player_sequence()

func _on_star_button_pressed():
	if is_waiting_for_input:
		player_sequence.append(shapes[3])
		check_player_sequence()

func _on_reset_timer_timeout():
	$WinLoseUI/WinGraphic.visible = false
	$WinLoseUI/LoseGraphic.visible = false
	reset_game()

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")

