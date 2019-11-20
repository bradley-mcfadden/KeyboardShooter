extends KinematicBody2D
export var movespeed:int = 50
var point:Vector2
var word:String = ""
func init(point:Vector2, word:String, position:Vector2):
	self.point = point
	self.word = word
	self.position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = word


func set_text(word:String):
	$Label.text = word


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	# var shift:Vector2 = (point - global_position).normalized()
	# position += shift * movespeed * delta

func _physics_process(delta):
	var shift:Vector2 = (point - global_position).normalized()
	var collision_info = move_and_collide(shift * movespeed * delta)
	if collision_info:
		move_and_collide(collision_info.normal * delta)