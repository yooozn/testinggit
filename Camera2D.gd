extends Camera2D

func _on_Player_grounded_updated(is_grounded):
	#note: This is kinda a temoprary solution
	#in the final version, the drag magrins will varry between levels 
	
	if is_grounded == true:
		drag_margin_v_enabled = false
	else:
		drag_margin_v_enabled = true
