extends Node2D

func _ready():
	$Damage.position = self.position
	$Damage.set_as_toplevel(1)
	$Damage.emitting = true
	pass # Replace with function body.

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
