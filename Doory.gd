extends StaticBody2D

var area = Area2D
func _process(delta):
	if Globals.door1 == false:
		$AnimatedSprite.play("Neutral")
	else:
		if Globals.door1 == true:
			$AnimatedSprite.play("Open")
			$CollisionShape2D.disabled = true
