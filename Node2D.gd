extends Node2D

onready var current_word:String = "bradley"
onready var cw_position:int = 0
onready var dict:Array
#onready var words_on_screen:Array
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	dict = []
	var dict_file = File.new()
	if !dict_file.file_exists("res://resources/dict.txt"):
		print("Error finding file")
		return
	dict_file.open("res://resources/dict.txt", File.READ)
	#print(dict_file.get_line())
	while !dict_file.eof_reached():
		#print("in loop")
		dict.push_back(dict_file.get_line().to_lower())
	dict_file.close()
	#print(dict.size())
	print(current_word)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event is InputEventKey && !event.is_echo():
		var entered_char = char(event.get_unicode())
		#print(entered_char)
		if cw_position >= current_word.length():
			current_word = dict[randi() % dict.size()]
			print(current_word)
			cw_position = 0
		if current_word[cw_position] == entered_char:
			#print("Correct")
			cw_position += 1
			print(current_word.substr(cw_position, current_word.length() - cw_position))

func insert_s(arr:Array, element):
	var size:int = arr.size()
	if (size == 0):
		arr.push_back(element)
		return
	if element >= arr[arr.size() - 1]:
		arr.push_back(element)
		return
	for i in range(arr.size()):
		if element < arr[i]:
			#print(element, " less than ", arr[i], " ", i)
			arr.insert(i, element)
			return