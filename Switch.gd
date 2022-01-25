extends Area2D

func _ready():
	$AnimatedSprite.play("Neutral")

func _on_Switch_area_entered(area):
	if area.is_in_group("Attack") and Input.is_action_pressed("attack"):
		$AnimatedSprite.play("Interact")
		$CollisionShape2D.queue_free()
		Globals.door1 = true
		print('Touhou')

#func _on_Switch_body_entered(body):
##	if body.is_in_group('Attack'):
##		$AnimatedSprite.play("Interact")
##		$CollisionShape2D.queue_free()
##		print(body.name)
#		print(body.position)
		
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Interact":
		$AnimatedSprite.stop()
		$AnimatedSprite.play("Ending")
