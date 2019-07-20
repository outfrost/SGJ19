extends KinematicBody

# Declare member variables here. Examples:
var falling = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if falling:
		var collisions = self.move_and_collide(Vector3(0.0, -1.0, 0.0).normalized() * 2.0 * delta, true, false)
		if collisions:
			print_debug(collisions)
			falling = false
