extends AnimationPlayer
var damage_particles = preload("res://Characters/Player/Damage.tscn")

func _ready():
	pass # Replace with function body.

func _damage(position):
	self.play("Damage")
	var particle_effect = damage_particles.instance()
	particle_effect.position = position
	add_child(particle_effect)
	pass
	