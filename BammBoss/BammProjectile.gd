extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time = 0
var target
onready var TweenNode = $Tween
var tick = 0
var startingPos

# Called when the node enters the scene tree for the first time.
func _ready():
	target = Globals.player.position
	startingPos = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	print(startingPos)
#	target = Globals.player.get_node("Position2D").global_position
#	print(target)
	time += delta
	if time >= 2.5 and tick == 3:
		queue_free()
		get_parent()._toIdle()
	elif get_parent().state == 'idle' or get_parent().state == 'attacking':
		queue_free()
	if time >= .5 and tick == 0:
		tick = 1
		TweenNode.interpolate_property(self, "position", position, target, .2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		TweenNode.start()
#		print(target)
	if time >= 1 and tick == 1:
		target = Globals.player.global_position
		tick = 2
		TweenNode.interpolate_property(self, "position", position, (target + Vector2(0,-250)), .2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		TweenNode.start()
	if time >= 1.5 and tick == 2:
		tick = 3
		TweenNode.interpolate_property(self, "position", position, startingPos, .2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		TweenNode.start()

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.damage(1)
