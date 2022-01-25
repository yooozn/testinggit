extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target
onready var TweenNode = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	target = Globals.player.global_position.x
	TweenNode.interpolate_property(self,"position:x", position.x, (position.x + 1250), 1.3,Tween.TRANS_LINEAR,Tween.EASE_IN)
	TweenNode.interpolate_property(self,"position:x", (position.x + 1250), position.x, 1.3,Tween.TRANS_LINEAR,Tween.EASE_IN, 1.3)
	TweenNode.start()
	yield(get_tree().create_timer(2.6),"timeout")
	queue_free()
	print(target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DiscAttack_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(1)
