extends CanvasLayer

signal transitioned


func ready():
	transition()

func transition():
	$AnimationPlayer.play("fade_to_black")
	print("Fading to Black...")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		print("Fading to White...")
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_white")
	if anim_name == "fade_to_white":
		print("Done!")
