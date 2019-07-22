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
	JUMPING_UP,
	STUCK
}

const movementSpeed = 0.5
const idleTime = 1.0

var climbingState = ClimbingState.IDLE
var idleTimeElapsed = 0.0

var monitor

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	match climbingState:
		ClimbingState.IDLE:
			if idleTimeElapsed < idleTime:
				idleTimeElapsed += delta
			else:
				var right = randf() >= 0.5
				var movementDirection = Vector3.RIGHT if right else Vector3.LEFT
				var collision = move_and_collide(movementDirection * 32.0, true, false, true)
				if collision and collision.collider is KinematicBody:
					climbingState = ClimbingState.ROLLING_RIGHT \
					                if right \
					                else ClimbingState.ROLLING_LEFT
				else:
					right = !right
					movementDirection = - movementDirection
					collision = move_and_collide(movementDirection * 32.0, true, false, true)
					if collision and collision.collider is KinematicBody:
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
			if collision:
				var collision2 = move_and_collide(Vector3.UP * movementSpeed * delta,
				                                  true,
				                                  false)
				if collision2:
					climbingState = ClimbingState.ROLLING_UP_LEFT
				else:
					move_and_collide(Vector3.LEFT * movementSpeed * delta * 3.0,
					                 true,
					                 false)
			else:
				climbingState = ClimbingState.IDLE
		ClimbingState.CLIMBING_RIGHT:
			var collision = move_and_collide(Vector3.RIGHT * movementSpeed * delta,
			                                 true,
			                                 false)
			if collision:
				var collision2 = move_and_collide(Vector3.UP * movementSpeed * delta,
				                                  true,
				                                  false)
				if collision2:
					climbingState = ClimbingState.ROLLING_UP_RIGHT
				else:
					move_and_collide(Vector3.RIGHT * movementSpeed * delta * 3.0,
					                 true,
					                 false)
			else:
				climbingState = ClimbingState.IDLE
		ClimbingState.ROLLING_UP_LEFT:
			var collision = move_and_collide(Vector3.UP * movementSpeed * delta,
			                                 true,
			                                 false)
			if collision and collision.collider is KinematicBody:
				var collision2 = move_and_collide(Vector3.RIGHT * movementSpeed * delta,
				                                  true,
				                                  false)
				if collision2:
					climbingState = ClimbingState.STUCK
					if monitor and monitor.has_method("lemmingStuck"):
						monitor.lemmingStuck(self)
				else:
					move_and_collide(Vector3.UP * movementSpeed * delta * 3,
					                 true,
					                 false)
				#move_and_slide_with_snap(Vector3.RIGHT * movementSpeed * delta,
				#                         Vector3(0.0, 4.0, 0.0),
				#                         zeroZ(collision.normal))
			else:
				climbingState = ClimbingState.CLIMBING_LEFT
		ClimbingState.ROLLING_UP_RIGHT:
			var collision = move_and_collide(Vector3.UP * movementSpeed * delta,
			                                 true,
			                                 false)
			if collision and collision.collider is KinematicBody:
				var collision2 = move_and_collide(Vector3.LEFT * movementSpeed * delta,
				                                  true,
				                                  false)
				if collision2:
					climbingState = ClimbingState.STUCK
					if monitor and monitor.has_method("lemmingStuck"):
						monitor.lemmingStuck(self)
				else:
					move_and_collide(Vector3.UP * movementSpeed * delta * 3,
					                 true,
					                 false)
				#move_and_slide_with_snap(Vector3.LEFT * movementSpeed * delta,
				#                         Vector3(0.0, 4.0, 0.0),
				#                         zeroZ(collision.normal))
			else:
				climbingState = ClimbingState.CLIMBING_RIGHT
		ClimbingState.JUMPING_LEFT:
			pass
		ClimbingState.JUMPING_RIGHT:
			pass
		ClimbingState.JUMPING_UP:
			pass
		_:
			pass

func zeroZ(vec : Vector3):
	return Vector3(vec.x, vec.y, 0.0)

func setMonitor(monitor : Object):
	self.monitor = monitor
