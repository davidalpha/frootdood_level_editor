extends RigidBody

export var SPEED = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	apply_impulse(transform.basis.z, -transform.basis.z * SPEED)
