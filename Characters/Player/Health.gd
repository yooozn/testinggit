extends CanvasLayer

var damage_particles = preload("res://Characters/Player/Damage.tscn")

#func _process(delta):
#	if Globals.cutscene == true:
#		$ui.hide()
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_health_update(health_):
	print('test')
	if health_ == 5:
		$"Health_Bar_2 (1)/1".visible = true
		$"Health_Bar_2 (1)/2".visible = true
		$"Health_Bar_2 (1)/3".visible = true
		$"Health_Bar_2 (1)/4".visible = true
		$"Health_Bar_2 (1)/5".visible = true
		
	if health_ == 4:
		$"Health_Bar_2 (1)/1".visible = true
		$"Health_Bar_2 (1)/2".visible = true
		$"Health_Bar_2 (1)/3".visible = true
		$"Health_Bar_2 (1)/4".visible = true
		$"Health_Bar_2 (1)/5".visible = false
		var particle_effect = damage_particles.instance()
		particle_effect.position = $"Health_Bar_2 (1)/5".position
		add_child(particle_effect)
	if health_ == 3:
		$"Health_Bar_2 (1)/1".visible = true
		$"Health_Bar_2 (1)/2".visible = true
		$"Health_Bar_2 (1)/3".visible = true
		$"Health_Bar_2 (1)/4".visible = false
		$"Health_Bar_2 (1)/5".visible = false
		var particle_effect = damage_particles.instance()
		particle_effect.position = $"Health_Bar_2 (1)/4".position
		add_child(particle_effect)
	if health_ == 2:
		$"Health_Bar_2 (1)/1".visible = true
		$"Health_Bar_2 (1)/2".visible = true
		$"Health_Bar_2 (1)/3".visible = false
		$"Health_Bar_2 (1)/4".visible = false
		$"Health_Bar_2 (1)/5".visible = false
		var particle_effect = damage_particles.instance()
		particle_effect.position = $"Health_Bar_2 (1)/3".position
		add_child(particle_effect)
	if health_ == 1:
		$"Health_Bar_2 (1)/1".visible = true
		$"Health_Bar_2 (1)/2".visible = false
		$"Health_Bar_2 (1)/3".visible = false
		$"Health_Bar_2 (1)/4".visible = false
		$"Health_Bar_2 (1)/5".visible = false
		var particle_effect = damage_particles.instance()
		particle_effect.position = $"Health_Bar_2 (1)/2".position
		add_child(particle_effect)
	if health_ == 0:
		$"Health_Bar_2 (1)/1".visible = false
		$"Health_Bar_2 (1)/2".visible = false
		$"Health_Bar_2 (1)/3".visible = false
		$"Health_Bar_2 (1)/4".visible = false
		$"Health_Bar_2 (1)/5".visible = false
		var particle_effect = damage_particles.instance()
		particle_effect.position = $"Health_Bar_2 (1)/1".position
		add_child(particle_effect)
	
	pass # Replace with function body.
