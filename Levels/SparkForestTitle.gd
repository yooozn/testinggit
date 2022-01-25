extends CanvasLayer



func _on_Timer_timeout():
	$"SparkForest".value += 1
	$"SparkForest".modulate.a += .01
	$"SparkForest".self_modulate.a += .01
	if $"SparkForest".value > 99:
		$Timer2.start()
		$Timer.stop()
		print("It works?")
		

func _on_Timer2_timeout():
	$"SparkForest".value -= 1
	$"SparkForest".modulate.a -= .01
	$"SparkForest".self_modulate.a -= .01
