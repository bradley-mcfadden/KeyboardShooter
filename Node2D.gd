extends Node2D

onready var current_word:String = ""
onready var cw_position:int = 0
onready var enemy_dict:Dictionary
onready var dict:Array
onready var words_on_screen:Array
onready var score:int = 0
onready var Enemy:PackedScene = preload("res://Enemy.tscn")
var WIDTH:int = ProjectSettings.get_setting("display/window/size/width")
var HEIGHT:int = ProjectSettings.get_setting("display/window/size/height")
export var health:int = 5
onready var STARTING_HEALTH = health
export var STARTING_INTERVAL:float = 2.0
#warning-ignore:integer_division
#warning-ignore:integer_division
var CENTER:Vector2 = Vector2(WIDTH / 2, HEIGHT / 2)


# Initializes several things such as starting the spawn timer
# as well as buidling the dictionary
func _ready():
	# print(CENTER)
	randomize()
	dict = []
	var dir:Directory = Directory.new()
	if dir.open("res://resources") == OK:
		dir.list_dir_begin(true, true)
		var file_name:String = dir.get_next()
		while (file_name != ""):
			if file_name == "." || file_name == "..":
				file_name = dir.get_next()
				continue
				# print("Found directory: " + file_name)
			# print(file_name)
			var dict_file:File = File.new()
			dict_file.open("res://resources/"+file_name, File.READ)
			# if dict_file.is_open():
			while dict_file.is_open() && !dict_file.eof_reached():
			#print("in loop")
				var s:String = String(dict_file.get_line())
				# print(s)
				dict.push_back(s.to_lower())
			dict_file.close()
			file_name = dir.get_next()
	#print(dict.size())
	enemy_dict = {}
	words_on_screen = []
	_on_Timer_timeout()


# Process keyboard input
func _input(event):
	# print("in echo")
	if event.is_echo():
		return
		
	if health <= 0:
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
			# print(current_word)
			
		if cw_position >= current_word.length() && words_on_screen.size() > 0:
			#current_word = dict[randi() % dict.size()]
			var index:int = words_on_screen.find(current_word)
			if index == -1:
				return
			words_on_screen.remove(index)
			enemy_dict[current_word].queue_free()
			score += 1
			if score / 10 >= 1 && score % 10 == 0:
				$SpawnTimer.wait_time *= 0.90
			$Counter.text = str(score)
			# print("WORD CLEARED")
			current_word = ""
			cw_position = 0
			return
			
		if current_word.length() > 0 && current_word[cw_position] == entered_char:
			#print("Correct")
			cw_position += 1
			# print(current_word.substr(cw_position, current_word.length() - cw_position))
			if health > 0:
				enemy_dict[current_word].set_text(current_word.substr(cw_position, 
					current_word.length() - cw_position))


# Insert an element into an array by ascending sort
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


# Find and return using binary search from a sorted array
func find_current_word(arr:Array, ch:String) -> String:
	var first:int = 0
	var last:int = arr.size() - 1
	var string:String = ""
	var found:bool = false
	while !found && first <= last:
		var middle:int = int(first + (last - first)/2 )
		if arr[middle][0] == ch:
			found = true
			string = arr[middle]
		elif arr[middle][0] > ch:
			last = middle - 1
		else:
			first = middle + 1
	return string 


# Return a point around the radius of a circle radiating from 
# center
func rand_point(center:Vector2, radius:int)->Vector2:
	var theta = rand_range(-1000, 1000)
	var x = center + Vector2(radius * cos(theta), radius * sin(theta))
	#print(x)
	return x


# On time out spawn, a new entity
func _on_Timer_timeout():
	var new_word:String = dict[randi() % dict.size()]
	while(enemy_dict.has(new_word)):
		new_word = dict[randi() % dict.size()]
	insert_s(words_on_screen, new_word)
	enemy_dict[new_word] = Enemy.instance()
	# print(rand_point(CENTER, 200))
	if randi() % 2 == 1:
		enemy_dict[new_word].init(CENTER, new_word, rand_point(CENTER, 400))
	else:
		enemy_dict[new_word].init(CENTER, new_word, rand_point(CENTER, 400), 100)
	add_child(enemy_dict[new_word])
	# print(words_on_screen)


# Reduce health and end game if health <= 0
func _on_Fort_decrement_health():
	if $DamageTimer.is_stopped():
		$ProgressBar.value -= 1
		$DamageTimer.start()
		if $ProgressBar.value <= 0:
			for word in words_on_screen:
				enemy_dict[word].queue_free()
				$SpawnTimer.stop()
				$BaseHealth.text = "Game Over"
				$Button.visible = true


# Reset game
func _on_Button_pressed():
	enemy_dict = {}
	words_on_screen = []
	health = STARTING_HEALTH
	$ProgressBar.value = health
	score = 0
	$SpawnTimer.wait_time = STARTING_INTERVAL
	$SpawnTimer.start()
	$Counter.text = str(score)
	$Button.visible = false
	cw_position = 0
	current_word = ""
	$BaseHealth.text = "Score"
