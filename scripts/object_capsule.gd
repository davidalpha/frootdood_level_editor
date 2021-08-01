tool
extends RigidBody

var inwater = false

func _process(delta):
	if translation.y < 0:
		var ocean = get_parent().get_node('Ocean')

		translation = ocean.get_displace(translation)
