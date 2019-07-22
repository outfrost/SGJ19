extends Spatial

const numLemmings = 16

var lemmings = Array()
var camera

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	camera = get_node("/root/MainScene/BlockSpawner/MainCamera") as Spatial
	if !camera:
		print_debug("Fuck, no camera.")
	
	var lemmingScene = preload("res://character/lemming.tscn")
	for i in range(0, numLemmings):
		var lemming = lemmingScene.instance()
		lemmings.append(lemming)
		if lemming.has_method("setMonitor"):
			lemming.setMonitor(self)
		lemming.translate(Vector3(- 8.0 + (randf() * 16.0), 0.0, 0.0))
		add_child(lemming)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if is_inside_tree():
		for lemming in lemmings:
			var cameraToLemming = lemming.global_transform.origin - camera.global_transform.origin
			var angle = Vector3.FORWARD.angle_to(cameraToLemming)
			if angle > TAU / 7.0:
				lemmings.erase(lemming)
		if lemmings.size() == 0:
			endGame()

func lemmingStuck(lemming : Object):
	lemmings.erase(lemming)
	if lemmings.size() == 0:
		endGame()

func endGame():
	var node = get_node("/root/MainScene/BlockSpawner")
	if node and node.has_method("gameOver"):
		node.gameOver()