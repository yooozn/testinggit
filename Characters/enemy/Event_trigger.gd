extends Area2D

export var group = 'Null'
export var Event = 'Null'
export var Turn = false
export var Jump = false
export var Damage = 1
export var Can_damage = true
var velocity = Vector2(0,0)
var speed = 32 #Pixels per second

var health = 5
# Called when the node enters the scene tree for the first time.
func _on_Area2D_body_entered(Area2D):
	if Area2D.is_in_group('Player') and Can_damage == true:
		Area2D.damage(Damage)
	print('enemy')
	pass # Replace with function body..

func damage(damage):
	$Damage.play()
	$DamageTimer.start()
	Can_damage = false 
	print(damage)
	health -= 1
	if health == 0: 
		queue_free()
	$Enemy_effects.play("Stagger")
#	$Effects._damage()
	pass





func _on_DamageTimer_timeout():
	Can_damage = true
	pass # Replace with function body.
