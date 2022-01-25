extends Area2D
onready var TweenNode = $Tween
onready var shader = $Sprite.material

# boolean testing if player is in damage range, and if player hasnt been damaged in last .3 seconds
var can_damage = false
var health = 10
#Player variable
var player = null
var target = Vector2()
var dashAble = true
var dashNum = 0
var justDamaged = false
var startingPos
#Boolean testing if player is still in range after leaving the .3 seconds. Prevents player from being hit after leaving boss range
var stillInRange = false
# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = position


func _process(delta):
	#if player is in enemy range
	if can_damage == true and stillInRange == true and justDamaged == false:
		#prevent loop from looping more than once
		can_damage = false
		#Damage player 1
		player.damage(1)
		justDamaged = true
		#Wait three seconds
		yield(get_tree().create_timer(1.5),"timeout")
		#Is player still in hit range? if so damage player again, else forget player
		justDamaged = false
		if stillInRange == true:
			can_damage = true
		else:
			can_damage = false
#	print(justDamaged)
#			player = null
	if player:
		target = player.get_position()
		if dashAble == true and dashNum < 4:
			dashAble = false
			_Dash()
			yield(get_tree().create_timer(1),"timeout")
			if dashNum < 4:
				TweenNode.interpolate_property(self,"position", position, (position + Vector2(0,-150)), .3, Tween.TRANS_LINEAR, Tween.EASE_IN)
				TweenNode.start()
				yield(get_tree().create_timer(.6),"timeout")
				dashAble = true
			else:
				var shaderCol = shader.get_shader_param("flash_color")
				print(shaderCol)
				shader.set_shader_param("flash_color", Color(1,1,.67))
				yield(get_tree().create_timer(3),"timeout")
				shader.set_shader_param("flash_color",shaderCol)
				TweenNode.interpolate_property(self, "position", position, (startingPos + Vector2(0,-150)), .3, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
				TweenNode.start()
				yield(get_tree().create_timer(1),"timeout")
				dashNum = 0
				dashAble = true
#		if dashNum == 4:
#			yield(get_tree().create_timer(3),"timeout")
#			dashNum = 0
#			dashAble = true
#			print("dashNUm")
#	print(dashNum)
	if health <= 0:
		queue_free()
		
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		can_damage = true
		stillInRange = true
		player = body



func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		stillInRange = false

func _Dash():
	if player:
		TweenNode.interpolate_property(self, "position", position, target, .3, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
		TweenNode.start()
		dashNum += 1
		print("tween")
		
func damage(damage):
	health -= damage
	shader.set_shader_param("flash_modifier", 0)
	yield(get_tree().create_timer(.1),"timeout")
	shader.set_shader_param("flash_modifier", 1)
	print("shader")
	

