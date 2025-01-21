extends Node2D


# VARIABLES
@export var shapes : Array[Texture2D] = []
var shape_sequence = []
var current_index = 0
var is_displaying_sequence = true

# FUNCTIONS
func _ready():
	print ("Script is loading!!")
	randomize()
	generate_sequence(4)
	display_next_shape()
	current_index = 0
	
func generate_sequence(length):
	shape_sequence = []
	for i in range(length):
		shape_sequence.append(shapes[randi() % shapes.size()])
		
func display_next_shape():
	if current_index < shape_sequence.size():
		$GameUI/BigBox.texture = shape_sequence[current_index]
		current_index += 1
		$SequenceTimer.start()
	else:
		is_displaying_sequence = false
		print ("Sequence is complete!! Now waiting for player input")


func _on_sequence_timer_timeout():
	display_next_shape()
