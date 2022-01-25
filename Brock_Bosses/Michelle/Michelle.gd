extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var _anim_player = $AnimationPlayer
onready var TweenNode = $Tween
export var healthPhase1 = 10
export var healthPhase2 = 10
export var healthStealNum = 8
var healthStealCount = 0
var rng = RandomNumberGenerator.new()
var random
var phase = 1
var attack1_count = 0

onready var proj = preload("res://Brock_Bosses/Michelle/DiscAttack(attack3).tscn")
onready var proj2 = preload("res://Brock_Bosses/Michelle/DiscAttack2.tscn")
onready var proj3 = preload("res://Brock_Bosses/Michelle/DiscAttack.tscn")
onready var proj4 = preload("res://Brock_Bosses/Michelle/DiscAttack(attack3)2.tscn")

onready var shader = $AnimatedSprite.material

var canDamage = false
var inRange = false
var immunity = false

var randNot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$DetectionArea/CollisionShape2D.set_deferred("disabled", false)
	_anim_player.play("idle")
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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


func _on_DetectionArea_body_entered(body):
	if body.is_in_group("Player"):
		_anim_player.play("start")
		position += Vector2(-120,46)
		$DetectionArea/CollisionShape2D.set_deferred("disabled", true)
		yield(get_tree().create_timer(1.7),"timeout")
		position -= Vector2(-120,46)
		_attack()

func _attack():
	random = rng.randi_range(1,3)
#	projectile()
	if random == 1 and attack1_count <= 3:
		randNot = 1
		attack1_count += 1
		_attack1()
	elif random == 2 and randNot != 2:
		randNot = 2
		attack1_count = 0
		_attack2()
	elif random == 3 and randNot != 3:
		randNot = 3
		attack1_count = 0
		_attack3()
	else:
		_attack()

func _attack1():
	var direction = $AnimatedSprite.global_position.x - Globals.player.position.x
	var target = Globals.player.position - Vector2(976,1640)
	TweenNode.interpolate_property(self, "position:x", position.x, target.x, .8,Tween.TRANS_LINEAR,Tween.EASE_IN)
	TweenNode.interpolate_property(self, "position:y", 0, -300, .4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	TweenNode.interpolate_property(self, "position:y", -300, 0, .4,Tween.TRANS_LINEAR,Tween.EASE_IN,.4)
	TweenNode.start()
	if direction >= 1:
		_anim_player.play("attack1")
	else:
		_anim_player.play("attack1 right")
	if phase == 1:
		yield(get_tree().create_timer(2.5),"timeout")
	elif phase == 2:
		yield(get_tree().create_timer(1.8),"timeout")
	_attack()

#NEW BEFORE WEEKEND ATTACK 2 JUST IMPLEMENTED, FIX LOCATION (positionPLAYer) Try using -/+ instead of division based off direction
func _attack2():
	var positionPlayer = (Globals.player.position - Vector2(976,1640)) / 2
	position.x += positionPlayer.x
	var direction = $AnimatedSprite.global_position.x - Globals.player.position.x
	if direction >= 1:
		_anim_player.play("attack2noDisc")
	else:
		_anim_player.play("attack2 right no disc")
	if phase == 1:
		yield(get_tree().create_timer(3.8),"timeout")
	elif phase == 2:
		yield(get_tree().create_timer(3),"timeout")
	position.x -= positionPlayer.x
	_attack()

func damage(damage):
	healthStealCount += 1
	if healthStealCount >= healthStealNum and Globals.player.health < 5:
		healthStealCount = 0
		Globals.player.health += 1
		Globals.player.health_update()
	if phase == 1:
		healthPhase1 -= damage
		shader.set_shader_param("flash_modifier", 1)
		yield(get_tree().create_timer(.07),"timeout")
		shader.set_shader_param("flash_modifier", 0)
		if healthPhase1 <= 0:
			phase = 2
	elif phase == 2:
		healthPhase2 -= damage
		shader.set_shader_param("flash_modifier", 1)
		yield(get_tree().create_timer(.07),"timeout")
		shader.set_shader_param("flash_modifier", 0)
		if healthPhase2 <= 0:
			queue_free()


func _on_Michelle_body_entered(body):
	if body.is_in_group("Player"):
		canDamage = true
		inRange = true


func _on_Michelle_body_exited(body):
	if body.is_in_group("Player"):
		inRange = false

func projectile():
	var proj1 = proj.instance()
	proj1.position = position + Vector2(-100,90)
	get_parent().add_child(proj1)

func projectile2():
	var proj1 = proj4.instance()
	proj1.position = position + Vector2(100,90)
	get_parent().add_child(proj1)

func projectile3():
	if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 1:
		yield(get_tree().create_timer(1),"timeout")
		var proj1 = proj2.instance()
		proj1.position = position + Vector2(rng.randi_range(-200, 200),rng.randi_range(-200,80))
		get_parent().add_child(proj1)
		yield(get_tree().create_timer(.6),"timeout")
		var proj22 = proj2.instance()
		proj22.position = position + Vector2(rng.randi_range(-200, 200),rng.randi_range(-200,80))
		get_parent().add_child(proj22)
		yield(get_tree().create_timer(.6),"timeout")
		var proj3 = proj2.instance()
		proj3.position = position + Vector2(rng.randi_range(-200, 200),rng.randi_range(-200,80))
		get_parent().add_child(proj3)
	else:
		yield(get_tree().create_timer(1),"timeout")
		var proj1 = proj3.instance()
		proj1.position = position + Vector2(rng.randi_range(-200, 200),rng.randi_range(-200,80))
		get_parent().add_child(proj1)
		yield(get_tree().create_timer(.6),"timeout")
		var proj2 = proj3.instance()
		proj2.position = position + Vector2(rng.randi_range(-200, 200),rng.randi_range(-200,80))
		get_parent().add_child(proj2)
		yield(get_tree().create_timer(.6),"timeout")
		var proj33 = proj3.instance()
		proj33.position = position + Vector2(rng.randi_range(-200, 200),rng.randi_range(-200,80))
		get_parent().add_child(proj33)

func _attack3():
	if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 1:
		position += Vector2(-120,46)
		_anim_player.play("attack3")
		projectile3()
		yield(get_tree().create_timer(5),"timeout")
		position -= Vector2(-120,46)
		_attack()
	else:
		position += Vector2(120,46)
		_anim_player.play("attack3 right")
		projectile3()
		yield(get_tree().create_timer(5),"timeout")
		position -= Vector2(120,46)
		_attack()
