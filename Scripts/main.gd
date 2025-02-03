extends Node2D


# VARIABLES
@export var shapes : Array[Texture2D] = []
var shape_sequence = []
var player_sequence = []
var is_waiting_for_input = false
var current_index = 0
var is_displaying_sequence = true
var score = 0

# FUNCTIONS
func _ready():
	#print ("Script is loading!!")
	randomize()
	generate_sequence(4)
	display_next_shape()
	current_index = 0
	
func generate_sequence(length):
	if length > shapes.size():
		print ("Error, length is too much")
		return
		
	var shuffled_shapes = shapes.duplicate()
	shuffled_shapes.shuffle()

	shape_sequence = shuffled_shapes.slice(0, length)
	
	
func reset_game():
	player_sequence.clear()
	current_index = 0
	is_waiting_for_input = false
	
	generate_sequence(4)
	#print ("Hey,new round has started!!!")
	
	
func check_player_sequence():
	if player_sequence.size() == shape_sequence.size():
		if player_sequence == shape_sequence:
			show_graphic("win")
			increase_score()
		else:
			show_graphic("lose")
			decrease_score()
		$ResetTimer.start()	
		
	
func display_next_shape():
	if current_index < shape_sequence.size():
		$GameUI/BigBox.texture = shape_sequence[current_index]
		current_index += 1
		$SequenceTimer.start()
	else:
		is_displaying_sequence = false
		is_waiting_for_input = true
		print ("Sequence is complete!! Now waiting for player input")


func _on_sequence_timer_timeout():
	display_next_shape()
	
	
	
func show_graphic(outcome: String):
	$WinLoseUI/WinGraphic.visible = outcome == "win"
	$WinLoseUI/LoseGraphic.visible = outcome == "lose"
	
	
	
func increase_score():
	score += 1
	$GameUI/ScoreContainer/ScoreValue.text = str(score)
	
func decrease_score():
	score -= 1
	$GameUI/ScoreContainer/ScoreValue.text = str(score)
	
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
