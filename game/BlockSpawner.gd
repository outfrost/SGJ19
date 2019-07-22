extends Spatial

# Declare member variables here.
const blockScenePaths = PoolStringArray([ "res://item/cart.tscn",
                                          "res://item/cucumbertower.tscn",
                                          "res://item/eiffeltower.tscn",
                                          "res://item/factory.tscn",
                                          "res://item/tetrisblockL.tscn",
                                          "res://item/tetrisblockI.tscn",
                                          "res://item/tetrisblockT.tscn" ])
const spawnInterval = 3.0
const advanceVelocity = Vector3(0.0, 0.25, 0.0)

var started = false
var going = true

var timeSinceLastSpawn = spawnInterval
var itemScenes = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	for path in blockScenePaths:
		itemScenes.append(load(path))
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !started:
		spawnItem()
		started = true

func _physics_process(delta):
	if going:
		translate(advanceVelocity * delta)

func spawnItem():
	var spatial = randomItemScene().instance() as Spatial
	var scriptable = spatial.find_node("Kinematic*")
	if scriptable.has_method("setSpawner"):
		scriptable.setSpawner(self)
	spatial.translation = translation
	get_parent().add_child(spatial)

func randomItemScene():
	return itemScenes[int(rand_range(0, itemScenes.size() - 0.5))]

func nextBlock():
	spawnItem()

func gameOver():
	going = false
