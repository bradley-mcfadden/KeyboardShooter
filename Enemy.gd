extends KinematicBody2D
class_name Enemy

export var movespeed:float = 50.0
var point:Vector2
var word:String = ""


func init(point:Vector2, word:String, position:Vector2, movespeed:float = 50.0):
	self.point = point
	self.word = word
	self.position = position
	self.movespeed = movespeed


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = word


func set_text(word:String):
	$Label.text = word


func _physics_process(delta):
	var shift:Vector2 = (point - global_position).normalized()
	var collision_info = move_and_collide(shift * movespeed * delta)
	if collision_info:
		move_and_collide(collision_info.normal * delta)