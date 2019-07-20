extends KinematicBody

enum ClimbingState {
	IDLE,
	ROLLING_LEFT,
	ROLLING_RIGHT,
	CLIMBING_LEFT,
	CLIMBING_RIGHT,
	ROLLING_UP_LEFT,
	ROLLING_UP_RIGHT,
	JUMPING_LEFT,
	JUMPING_RIGHT,
	JUMPING_UP
}

const movementSpeed = 1.0
const idleTime = 1.0

var climbingState = ClimbingState.IDLE
var idleTimeElapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	match climbingState:
		ClimbingState.IDLE:
			idleTimeElapsed += delta
			if idleTimeElapsed >= idleTime:
				var movementDirection = Vector3(1.0 if randf() >= 0.5 else -1.0, 0.0, 0.0)
				var collision = move_and_collide(movementDirection * 32.0, true, false, true)
				if collision.collider is KinematicBody:
					climbingState = ClimbingState.ROLLING_LEFT
				else:
					movementDirection = - movementDirection
					collision = move_and_collide(movementDirection * 32.0, true, false, true)
					if collision.collider is KinematicBody:
						pass # Move towards the detected KinematicBody
		ClimbingState.ROLLING_LEFT:
			pass
		ClimbingState.ROLLING_RIGHT:
			pass
		ClimbingState.CLIMBING_LEFT:
			pass
		ClimbingState.CLIMBING_RIGHT:
			pass
		ClimbingState.ROLLING_UP_LEFT:
			pass
		ClimbingState.ROLLING_UP_RIGHT:
			pass
		ClimbingState.JUMPING_LEFT:
			pass
		ClimbingState.JUMPING_RIGHT:
			pass
		ClimbingState.JUMPING_UP:
			pass
	
	if movementDirection.abs() == 0.0:
		movementDirection = Vector3(1.0 if randf() >= 0.5 else -1.0, 0.0, 0.0)
		var collision = move_and_collide(movementDirection * 32.0, true, false, true)
		if collision.collider is KinematicBody:
			pass # Move towards the detected KinematicBody
		else:
			movementDirection = - movementDirection
			collision = move_and_collide(movementDirection * 32.0, true, false, true)
			if collision.collider is KinematicBody:
				pass # Move towards the detected KinematicBody
	else:
		var collision = move_and_collide(movementDirection * movementSpeed * delta, true, false)
		if collision:
			move_and_slide_with_snap(movementDirection * movementSpeed * delta,
			                         movementDirection,
			                         collision.normal)
