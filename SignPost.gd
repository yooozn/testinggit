extends Area2D


func _on_SignPost_body_entered(body):
	if body.is_in_group("Player"):
		$"End".stop()
		$"Start".start()
#		if $"TextureProgress".value > 99:
#			$

func _on_Start_timeout():
	$"TextureProgress".value += .01
	$"TextureProgress".modulate.a += .02
	$"TextureProgress".self_modulate.a += .02
	print("Requires your soul")
	
func _on_End_timeout():
	$"TextureProgress".value -= .01
	$"TextureProgress".modulate.a -= .02
	$"TextureProgress".self_modulate.a -= .02
	
func _on_SignPost_body_exited(body):
	if body.is_in_group("Player"):
		$"Start".stop()
		$"End".start()


func _on_Timer_timeout():
			$"Start".stop()
			$"End".start()
