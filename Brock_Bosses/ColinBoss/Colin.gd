extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _anim_player = $AnimationPlayer
onready var TweenNode = $Tween

onready var shader = $AnimatedSprite.material

var rng = RandomNumberGenerator.new()
var direction = ""
var numAttacks = 0
onready var projectile = preload("res://Brock_Bosses/ColinBoss/ColinProjectile.tscn")
onready var projectile2 = preload("res://Brock_Bosses/ColinBoss/ColinProjectile2.tscn")
# Called when the node enters the scene tree for the first time.

var phase = 1

var randomNot = 0

var cooldown = false

export var healthPhase1 = 10
export var healthPhase2 = 10

export var healthStealNum = 8
var healthStealCount = 0

var canDamage = false
var inRange = false
var immunity = false

func _ready():
	rng.randomize()
	_anim_player.play("idle")
	$DetectionRange/CollisionShape2D.set_deferred("disabled", false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if healthPhase1 == 0:
		phase = 2
		print("phase2")
	if healthPhase2 == 0:
		queue_free()
	if canDamage == true and inRange == true and immunity == false:
		Globals.player.damage(1)
		canDamage = false
		immunity = true
		yield(get_tree().create_timer(1),"timeout")
		immunity = false
		if inRange == true:
			canDamage = true
		else:
			canDamage = false


func _on_DetectionRange_body_entered(body):
	if body.is_in_group("Player"):
		$DetectionRange/CollisionShape2D.set_deferred("disabled", true)
		_anim_player.play("start")
		yield(get_tree().create_timer(3),"timeout")
		_attack()


func _attack():
	var random
	if phase == 1:
		random = rng.randi_range(1,2)
	elif phase == 2:
		random = rng.randi_range(1,3)
#	print($AnimatedSprite.global_position)
	if random == 1 and randomNot != 1:
		randomNot = 1
		numAttacks = rng.randi_range(1,4)
		_attack1()
	elif random == 2 and randomNot != 2:
		randomNot = 2
		_attack2()
	elif random == 3 and randomNot != 3:
		randomNot = 3
		_attack3()
	else:
		_attack()

func _attack1():
#	var target = Globals.player.global_position - Vector2(1008, 1824)
	numAttacks -= 1
	var direction = $AnimatedSprite.global_position - Globals.player.global_position
	if direction.x >= 0:
		var target = Globals.player.global_position - Vector2(1008, 1824)
		#Change target to a max / min value depending on direction, and distance^^
		_anim_player.play("attack1")
		TweenNode.interpolate_property(self, "position:x", position.x, target.x, .7,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.interpolate_property(self, "position:y", position.y, (target.y - 200), .35,Tween.TRANS_QUAD,Tween.EASE_OUT)
		TweenNode.interpolate_property(self, "position:y", (target.y - 200), 0, .35,Tween.TRANS_QUAD,Tween.EASE_IN,.35)
		TweenNode.start()
#		TweenNode.interpolate_property(self, "position", position, target, .7,Tween.TRANS_LINEAR,Tween.EASE_IN)
#		TweenNode.start()
		if phase == 1:
			yield(get_tree().create_timer(2.5),"timeout")
		elif phase == 2:
			yield(get_tree().create_timer(2),"timeout")
		if numAttacks >= 1:
			print(numAttacks)
			_attack1()
		else:
			var AttackMid = rng.randi_range(1,2)
			if AttackMid == 1:
				_attack2()
			else:
				_attack()
	else:
		var target = Globals.player.global_position - Vector2(1008, 1824)
		#Change target to a max / min value depending on direction, and distance^^
		_anim_player.play("attack1 right")
#		TweenNode.interpolate_property(self, "position", position, target, .7,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.interpolate_property(self, "position:x", position.x, target.x, .7,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.interpolate_property(self, "position:y", position.y, (target.y - 200), .35,Tween.TRANS_QUAD,Tween.EASE_OUT)
		TweenNode.interpolate_property(self, "position:y", (target.y - 200), 0, .35,Tween.TRANS_QUAD,Tween.EASE_IN,.35)
		TweenNode.start()
		if phase == 1:
			yield(get_tree().create_timer(2.6),"timeout")
		elif phase == 2:
			yield(get_tree().create_timer(2),"timeout")
		if numAttacks >= 1:
			print(numAttacks)
			_attack1()
		else:
			var AttackMid = rng.randi_range(1,2)
			if AttackMid == 1:
				_attack2()
			else:
				_attack()
func Middle():
	if position.x <= 0:
		var targetx = 0
		var targety = -300
		_anim_player.play("attack1 right")
		TweenNode.interpolate_property(self, "position:x", position.x, targetx, 1, Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.interpolate_property(self, "position:y", position.y, targety, .5, Tween.TRANS_QUAD,Tween.EASE_OUT)
		TweenNode.interpolate_property(self, "position:y", targety, 0, .5, Tween.TRANS_QUAD,Tween.EASE_IN, .5)
		TweenNode.start()
		yield(get_tree().create_timer(1),"timeout")
		_projectile2()
		yield(get_tree().create_timer(.5),"timeout")
		Idle()
	else:
		var targetx = 0
		var targety = -300
		_anim_player.play("attack1")
		TweenNode.interpolate_property(self, "position:x", position.x, targetx, 1, Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.interpolate_property(self, "position:y", position.y, targety, .5, Tween.TRANS_QUAD,Tween.EASE_OUT)
		TweenNode.interpolate_property(self, "position:y", targety, position.y, .5, Tween.TRANS_QUAD,Tween.EASE_IN, .5)
		TweenNode.start()
		yield(get_tree().create_timer(1),"timeout")
		_projectile()
		yield(get_tree().create_timer(.5),"timeout")
		Idle()

func Idle():
	_anim_player.play("idle")
	if phase == 1:
		yield(get_tree().create_timer(2.2),"timeout")
	elif phase == 2:
		yield(get_tree().create_timer(1.4),"timeout")
	_attack()

func _attack2():
	var direction = $AnimatedSprite.global_position - Globals.player.global_position
	if direction.x >= 0:
		_anim_player.play("attack2")
	else:
		_anim_player.play("attack2 right")
	if phase == 1:
		yield(get_tree().create_timer(2.7),"timeout")
	elif phase == 2:
		yield(get_tree().create_timer(2),"timeout")
	Middle()

func _attack3():
	var direction = $AnimatedSprite.global_position - Globals.player.global_position
	var target = Globals.player.global_position.x - 1008
	if direction.x >= 0:
		TweenNode.interpolate_property(self, "position:x", (position.x - 150), target, 1,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
		_anim_player.play("attack3")
		yield(get_tree().create_timer(2.2),"timeout")
		Middle()
	else:
		TweenNode.interpolate_property(self, "position:x", (position.x + 150), target, 1,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
		_anim_player.play("attack3 right")
		yield(get_tree().create_timer(2.2),"timeout")
		Middle()
	
#323
#192

func _projectile():
	var proj = projectile.instance()
	proj.position = position
	get_parent().add_child(proj)
	print(str(position) + "BOSS POSITION")

func _projectile2():
	var proj = projectile2.instance()
	proj.position = position
	get_parent().add_child(proj)


func _on_Colin_body_entered(body):
	if body.is_in_group("Player"):
		canDamage = true
		inRange = true


func _on_Colin_body_exited(body):
	if body.is_in_group("Player"):
		inRange = false

func damage(damage):
	healthStealCount += 1
	if healthStealCount >= healthStealNum and Globals.player.health < 5:
		healthStealCount = 0
		Globals.player.health += 1
		Globals.player.health_update()
	if phase == 1:
		healthPhase1 -= 1
	else:
		healthPhase2 -= 1
	shader.set_shader_param("flash_modifier", 1)
	yield(get_tree().create_timer(.07),"timeout")
	shader.set_shader_param("flash_modifier", 0)
