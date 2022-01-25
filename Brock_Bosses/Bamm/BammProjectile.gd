extends Area2D

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var startScale = rng.randf_range(0.2,4)
	var endScale = rng.randf_range(.2,4)
	$Tween.interpolate_property(self, "position:x", position.x, position.x + 2000, rng.randf_range(.6, 1.5),Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.interpolate_property(self, "scale", Vector2(startScale,startScale), Vector2(endScale,endScale),rng.randf_range(.1,4.0),Tween.TRANS_LINEAR,Tween.EASE_IN)
	$Tween.start()
	yield(get_tree().create_timer(3),"timeout")
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BammProjectile_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(1)
