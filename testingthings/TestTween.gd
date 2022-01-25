extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var TweenNode = get_node("Tween")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	
	TweenNode.interpolate_property(self, "position", position, mouse_pos, .1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	TweenNode.start()
#object: Object, property: NodePath, initial_val: Variant, 
#final_val: Variant, duration: float, trans_type: TransitionType = 0, ease_type: EaseType = 2, delay: float = 0)
