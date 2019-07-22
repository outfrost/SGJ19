extends KinematicBody

const fallVelocity = Vector3(0.0, -3.0, 0.0)
const drop = Vector3(0.0, -1024.0, 0.0)
const movementVelocity = Vector3(10.0, 0.0, 0.0)

# Declare member variables here. Examples:
var falling = true
var spawner

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if falling:
		if Input.is_action_pressed("move_block_left"):
			move_and_collide(- movementVelocity * delta, true, false)
		if Input.is_action_pressed("move_block_right"):
			move_and_collide(movementVelocity * delta, true, false)
		
		if Input.is_action_just_pressed("rotate_block"):
			rotate_z(TAU / 4.0)
		if Input.is_action_just_pressed("drop_block"):
			move_and_collide(drop, true, false)
			falling = false
			if spawner and spawner.has_method("nextBlock"):
				spawner.nextBlock()
		elif move_and_collide(fallVelocity * delta, true, false):
			falling = false
			if spawner and spawner.has_method("nextBlock"):
				spawner.nextBlock()

func setSpawner(spawner : Object):
	self.spawner = spawner
