extends KinematicBody2D
signal decrement_health
class_name Fort


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var collision_info = move_and_collide(Vector2(0, 0))
	if collision_info:
		if collision_info.collider is Enemy:
			emit_signal("decrement_health")