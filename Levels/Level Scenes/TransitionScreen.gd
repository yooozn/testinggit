extends CanvasLayer

signal transitioned

func _ready():
	#The function transitions
	transition()
	
	
func transition():
	#Plays the transitions...
	$AnimationPlayer.play("fade_to_black")
	#Prints it just incase
	print("Fading away....")

func _on_AnimationPlayer_animation_finished(anim_name):
	#If the animation is finished then it emits a signal of it transitioned then the animation player then fades to white
	if anim_name == "fade_to_black":
		print("Make trans")
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_white")
	if anim_name == "fade_to_white":
		print("Finished fading")
