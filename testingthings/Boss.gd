extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()
var target = Vector2()
var player = null
var health = 20
onready var _anim_player = get_parent().get_node("AnimationPlayer")
onready var shader = $AnimatedSprite.material
onready var TweenNode = $Tween
var state
var canDamage = false
var inRange = false
var immunity = false
var direction = null

var targetPosX
var targetPosY
var targetPos

var idlecount = 1
var count = 0

var posInstance

var random
var randomNot = 0
var just_hit = false

onready var projectile = preload("res://BammBoss/BammProjectile.tscn")
onready var projectile2 = preload("res://BammBoss/BammProjectile2.tscn")
onready var projectile3 = preload("res://BammBoss/BammProjectile2.5.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	_anim_player.play("Idle")
#	state = 'idle'


func _process(delta):
#	print(direction)
#	print(targetPos)
#	print(direction)
	if player:
		target = player.global_position
	if health == 0:
		queue_free()
	if canDamage == true and inRange == true and immunity == false:
		player.damage(1)
		canDamage = false
		immunity = true
		yield(get_tree().create_timer(1),"timeout")
		immunity = false
		if inRange == true:
			canDamage = true
		else:
			canDamage = false
	if state == 'idle':
#		player = Globals.player
		print("IDLE POSITION" + str(position))
		count = 0
		state = 'attacking'
		_anim_player.play("IdleInvisible")
		yield(get_tree().create_timer(idlecount),"timeout")
		idlecount -= .07
		print("idle" + str(idlecount))
		targetPosX = target.x
		targetPos = target
		attack()
#		print(targetPos)
#		print(position.x)
#		yield(get_tree().create_timer(2),"timeout")
		#print("attacking")
		

func _on_Detection_Range_body_entered(body):
	print("entereddd")
	if body.is_in_group("Player"):
		$"Detection Range/CollisionShape2D".set_deferred("disabled", true)
		player = body
		_anim_player.play("Start")
		yield(get_tree().create_timer(2.3),"timeout")
		_anim_player.play("DisappearUp")
		state = 'idle'
		print("PLAYERRRRRRRRR")
#		print("entered")
		#print("detectionRange")

func damage(damage):
	health -= 1
	shader.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(.07),"timeout")
	shader.set_shader_param("flash_modifier", 0)

func _on_Boss_body_entered(body):
	if body.is_in_group("Player"):
		canDamage = true
		inRange = true


func _on_Boss_body_exited(body):
	if body.is_in_group("Player"):
		inRange = false

func _AppearUp():
	if state == 'attacking':
		state = 'attacking2'
		if random == 1:
			print("ATTACK 1")
			if direction == 'right':
				TweenNode.interpolate_property(self, "position", global_position, (global_position + Vector2(-70, -1350)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
				TweenNode.start()
				yield(get_tree().create_timer(.55),"timeout")
	#			print("should print after")
				_Transform()
				_anim_player.play("Attack1 Right")
				yield(get_tree().create_timer(.85),"timeout")
				state = 'idle'
			elif direction == 'left':
				TweenNode.interpolate_property(self, "position", global_position, (global_position + Vector2(70, -1350)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
				TweenNode.start()
				yield(get_tree().create_timer(.55),"timeout")
	#			print("should print after")
				_Transform()
				_anim_player.play("Attack1")
				yield(get_tree().create_timer(.85),"timeout")
				state = 'idle'
			print("ATTACK 1 POSITION" + str(position))
		#	if !_anim_player.current_animation == "Attack1":
		#		state = 'idle'
		#		print("appearup")
		#	elif !_anim_player.current_animation == "Attack1 Right":
		#		state = 'idle'
	#		print("should print before")
	#		yield(get_tree().create_timer(1.4),"timeout")
	#		state = 'idle'
	#		print("should print after after")
		#Maybe random number choosing how many projectiles it shoots out, how many times animations repeats, and a count method counting each itme
		elif random == 3:
			print("ATTACK 3")
			TweenNode.interpolate_property(self, "position", position, Vector2(0,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
			TweenNode.start()
			yield(get_tree().create_timer(1),"timeout")
			_anim_player.play("Attack 4")
		elif random == 4:
			print("ATTACK 4")
			TweenNode.interpolate_property(self, "position", Vector2(0,0), Vector2(0, -150), .8, Tween.TRANS_LINEAR, Tween.EASE_IN)
			TweenNode.start()
			yield(get_tree().create_timer(1),"timeout")
			position += Vector2(-310,30)
			_anim_player.play("Attack3")
			yield(get_tree().create_timer(1.8),"timeout")
			_anim_player.play("Attack3 Left")
			yield(get_tree().create_timer(1.8),"timeout")
			state = 'idle'
		elif random == 5:
			print("ATTACK 5")
			TweenNode.interpolate_property(self, "position", position, Vector2(0,0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
			TweenNode.start()
			yield(get_tree().create_timer(1),"timeout")
			_anim_player.play("Attack 5")
			yield(get_tree().create_timer(2),"timeout")
			_anim_player.play("Attack 5")
			yield(get_tree().create_timer(2),"timeout")
			_anim_player.play("Attack 5")
			yield(get_tree().create_timer(2), "timeout")
			state = 'idle'
func _AppearDown():
	if state == 'attacking':
		state = 'attacking2'
		print("ATTACK 2")
		posInstance = global_position
		if direction == 'right':
#			TweenNode.interpolate_property(self, "position", position, (posInstance + Vector2(-70, 150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
#			TweenNode.start()
			TweenNode.interpolate_property(self, "position", global_position, (global_position + Vector2(100, -1200)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
			TweenNode.start()
			yield(get_tree().create_timer(.5),"timeout")
			_Transform()
			_anim_player.play("Attack2 Right")
			yield(get_tree().create_timer(.5),"timeout")
#			TweenNode.interpolate_property(self, "position", position, (posInstance + Vector2(-1000,-600)), .1, Tween.TRANS_LINEAR,Tween.EASE_IN)
#			TweenNode.start()
			TweenNode.interpolate_property(self, "position", global_position, (global_position + Vector2(-1600,-1200)), .7, Tween.TRANS_LINEAR,Tween.EASE_IN)
			TweenNode.start()
			yield(get_tree().create_timer(1),"timeout")
			state = 'idle'
		elif direction == 'left':
			TweenNode.interpolate_property(self, "position", global_position, (global_position + Vector2(-100, -1200)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
			TweenNode.start()
			yield(get_tree().create_timer(.5),"timeout")
			_Transform()
			_anim_player.play("Attack2")
			yield(get_tree().create_timer(.5),"timeout")
			TweenNode.interpolate_property(self, "position", global_position, (global_position + Vector2(1600,0)), .7,Tween.TRANS_LINEAR,Tween.EASE_IN)
			TweenNode.start()
			yield(get_tree().create_timer(1),"timeout")
			state = 'idle'
		print("ATTACK 2 POSITION" + str(position))
	#	if !_anim_player.current_animation == "Attack1":
	#		state = 'idle'
	#		print("appearup")
	#	elif !_anim_player.current_animation == "Attack1 Right":
	#		state = 'idle'
#		yield(get_tree().create_timer(2.1),"timeout")
#		#print("start")
#		state = 'idle'

func _BlinkUp():
	posInstance = position
	if direction == 'right':
		TweenNode.interpolate_property(self, "position", position, (posInstance + Vector2(-70, -150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
	elif direction == 'left':
		TweenNode.interpolate_property(self, "position", position, (posInstance + Vector2(70, -150)), .3,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()

func _Transform():
	posInstance = global_position
	if direction == 'right':
		self.global_position = global_position + Vector2(-100, 0)
	elif direction == 'left':
		self.global_position = global_position - Vector2(-100,1200)

func _TransformReset():
	posInstance = position
	if direction == 'right':
		self.position = posInstance + Vector2(100,0)
	elif direction == 'left':
		self.position = posInstance - Vector2(100,0)

func _idle():
	state = 'idle'

func _Projectile():
	print("projectile")
	var proj = projectile.instance()
	add_child(proj)
	proj.global_position = Globals.player.global_position + Vector2(rng.randi_range(-350, 350), rng.randi_range(-350, -500))
	var proj1 = projectile.instance()
	add_child(proj1)
	proj1.global_position = Globals.player.global_position + Vector2(rng.randi_range(-350, 350), rng.randi_range(-350, -500))
	var proj2 = projectile.instance()
	add_child(proj2)
	proj2.global_position = Globals.player.global_position + Vector2(rng.randi_range(-350, 350), rng.randi_range(-350, -500))
	var proj3 = projectile.instance()
	add_child(proj3)
	proj3.global_position = Globals.player.global_position + Vector2(rng.randi_range(-350, 350), rng.randi_range(-350, -500))
	var proj4 = projectile.instance()
	add_child(proj4)
	proj4.global_position = Globals.player.global_position + Vector2(rng.randi_range(-350, 350), rng.randi_range(-350, -500))
func _toIdle():
	state = 'idle'

func _ProjAttack2():
	var proj = projectile2.instance()
	get_parent().add_child(proj)
	proj.position = $AnimatedSprite.position + Vector2(-90,15)
	var proj2 = projectile3.instance()
	get_parent().add_child(proj2)
	proj2.position = $AnimatedSprite.position + Vector2(90,15)

func attack():
	random = rng.randi_range(1,5)
	if random == 1 and randomNot != 1:
		randomNot = 1
		if (targetPosX - $AnimatedSprite.global_position.x) > 1:
			global_position = (targetPos + Vector2(-400, -400))
			direction = 'right'
			_anim_player.play("AppearUp")
			#print("right")
		else:
			global_position = (targetPos + Vector2(-1000, -400))
			direction = 'left'
			_anim_player.play("AppearUpFlip")
			#print("left")
	elif random == 1 and randomNot == 1:
		attack()
	elif random == 2 and randomNot != 2:
		randomNot = 2
		if (target.x - $AnimatedSprite.global_position.x) > 1:
			global_position = (targetPos + Vector2(-400, -400))
			direction = 'right'
			_anim_player.play("AppearDown")
			#print("right")
		else:
			global_position = (targetPos + Vector2(-1000, -400))
			direction = 'left'
			_anim_player.play("AppearDownFlip")
			#print("left")
	elif random == 2 and randomNot == 2:
		attack()
	elif random == 3 and randomNot != 3:
		randomNot = 3
		_anim_player.play("AppearUp")
	elif random == 3 and randomNot == 3:
		attack()
	elif random == 4 and randomNot != 4:
		randomNot = 4
		_anim_player.play("AppearUp")
	elif random == 4 and randomNot == 4:
		attack()
	elif random == 5 and randomNot != 5:
		randomNot = 5
		_anim_player.play("AppearUp")
	elif random == 5 and randomNot == 5:
		attack()
