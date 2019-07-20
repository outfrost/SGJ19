extends Spatial

# Declare member variables here.
const blockScenePaths = PoolStringArray([ "res://items/cart01-01.tscn",
                                          "res://items/cucumbertower.tscn",
                                          "res://items/eiffeltower.tscn",
                                          "res://items/factory01-01.tscn",
                                          "res://items/tetrisblockL.tscn" ])
const spawnInterval = 3.0
const advanceVelocity = Vector3(0.0, 0.25, 0.0)

var timeSinceLastSpawn = spawnInterval
var itemScenes = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	for path in blockScenePaths:
		itemScenes.append(load(path))
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSinceLastSpawn += delta
	while timeSinceLastSpawn >= spawnInterval:
		timeSinceLastSpawn -= spawnInterval
		spawnItem()

func _physics_process(delta):
	translate(advanceVelocity * delta)

func spawnItem():
	var spatial = randomItemScene().instance() as Spatial
	spatial.translation = translation
	get_parent().add_child(spatial)

func randomItemScene():
	return itemScenes[int(rand_range(0, itemScenes.size() - 0.5))]
