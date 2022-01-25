extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var TweenNode = $Tween
# Called when the node enters the scene tree for the first time.
func _ready():
#	position += Vector2(-1008,-750)
#	print(global_position)
#	print(position)
	position += Vector2(0, 515)
	TweenNode.interpolate_property(self,"position", position, (position + Vector2(-3000,0)), 2.7,Tween.TRANS_LINEAR,Tween.EASE_IN)
	TweenNode.interpolate_property(self,"scale", scale, (scale + Vector2(4,4)), .7,Tween.TRANS_LINEAR,Tween.EASE_IN)
	TweenNode.start()
#	print(global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ColinProjectile_body_entered(body):
	if body.is_in_group("Player"):
		Globals.player.damage(1)
