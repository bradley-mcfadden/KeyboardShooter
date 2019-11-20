extends Node2D

onready var current_word:String = ""
onready var cw_position:int = 0
onready var enemy_dict:Dictionary
onready var dict:Array
onready var words_on_screen:Array
onready var Enemy:PackedScene = preload("res://Enemy.tscn")
var WIDTH:int = ProjectSettings.get_setting("display/window/size/width")
var HEIGHT:int = ProjectSettings.get_setting("display/window/size/height")
#warning-ignore:integer_division
#warning-ignore:integer_division
var CENTER:Vector2 = Vector2(WIDTH / 2, HEIGHT / 2)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(CENTER)
	randomize()
	enemy_dict = {}
	words_on_screen = []
	dict = []
	var dict_file = File.new()
	if !dict_file.file_exists("res://resources/dict.txt"):
		print("Error finding file")
		return
	dict_file.open("res://resources/dict.txt", File.READ)
	while !dict_file.eof_reached():
		#print("in loop")
		dict.push_back(dict_file.get_line().to_lower())
	dict_file.close()
	#print(dict.size())
	_on_Timer_timeout()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _input(event):
	if event.is_echo():
		return
	if event.is_action_pressed("backspace"):
		print("WORD ESCAPED")
		enemy_dict[current_word].set_text(current_word)
		cw_position = 0
		current_word = ""
	elif event is InputEventKey:
		var entered_char = char(event.get_unicode())
		if words_on_screen.size() > 0 && current_word == "":
			current_word = find_current_word(words_on_screen, entered_char)
			print(current_word)
			
		if cw_position >= current_word.length() && words_on_screen.size() > 0:
			#current_word = dict[randi() % dict.size()]
			var index:int = words_on_screen.find(current_word)
			if index == -1:
				return
			words_on_screen.remove(index)
			enemy_dict[current_word].free()
			print("WORD CLEARED")
			current_word = ""
			cw_position = 0
			return
			
		if current_word.length() > 0 && current_word[cw_position] == entered_char:
			#print("Correct")
			cw_position += 1
			print(current_word.substr(cw_position, current_word.length() - cw_position))
			enemy_dict[current_word].set_text(current_word.substr(cw_position, 
					current_word.length() - cw_position))


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


func find_current_word(arr:Array, ch:String) -> String:
	var first = 0
	var last = arr.size() - 1
	var string:String = ""
	var found:bool = false
	while !found && first <= last:
		var middle = int(first + (last - first)/2 )
		if arr[middle][0] == ch:
			found = true
			string = arr[middle]
		elif arr[middle][0] > ch:
			last = middle - 1
		else:
			first = middle + 1
	return string 


func rand_point(center:Vector2, radius:int)->Vector2:
	var theta = rand_range(-1000, 1000)
	
	var x = center + Vector2(radius * cos(theta), radius * sin(theta))
	print(x)
	return x


func _on_Timer_timeout():
	var new_word:String = dict[randi() % dict.size()]
	while(enemy_dict.has(new_word)):
		new_word = dict[randi() % dict.size()]
	insert_s(words_on_screen, new_word)
	enemy_dict[new_word] = Enemy.instance()
	# print(rand_point(CENTER, 200))
	enemy_dict[new_word].init(CENTER, new_word, rand_point(CENTER, 400))
	add_child(enemy_dict[new_word])
	print(words_on_screen)
