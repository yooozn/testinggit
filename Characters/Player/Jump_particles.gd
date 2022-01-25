extends Node2D

func _ready():
	$Trail.global_position = self.position
	$Dust.position = self.position
	$Dust.set_as_toplevel(1)
	$Dust.emitting = true
	pass # Replace with function body.

func _on_Timer_timeout():
	print('queue_free')
	queue_free()
	pass # Replace with function body.

