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
				var right = randf() >= 0.5
				var movementDirection = Vector3.RIGHT if right else Vector3.LEFT
				var collision = move_and_collide(movementDirection * 32.0, true, false, true)
				if collision.collider is KinematicBody:
					climbingState = ClimbingState.ROLLING_RIGHT \
					                if right \
					                else ClimbingState.ROLLING_LEFT
				else:
					right = !right
					movementDirection = - movementDirection
					collision = move_and_collide(movementDirection * 32.0, true, false, true)
					if collision.collider is KinematicBody:
						climbingState = ClimbingState.ROLLING_RIGHT \
						                if right \
						                else ClimbingState.ROLLING_LEFT
		ClimbingState.ROLLING_LEFT:
			var collision = move_and_collide(Vector3.LEFT * movementSpeed * delta,
			                                 true,
			                                 false)
			if collision:
				climbingState = ClimbingState.CLIMBING_LEFT
		ClimbingState.ROLLING_RIGHT:
			var collision = move_and_collide(Vector3.RIGHT * movementSpeed * delta,
			                                 true,
			                                 false)
			if collision:
				climbingState = ClimbingState.CLIMBING_RIGHT
		ClimbingState.CLIMBING_LEFT:
			var collision = move_and_collide(Vector3.LEFT * movementSpeed * delta,
			                                 true,
			                                 false)
			move_and_slide_with_snap(Vector3.UP * movementSpeed * delta,
			                         Vector3(- 4.0, 0.0, 0.0),
			                         collision.normal)
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
