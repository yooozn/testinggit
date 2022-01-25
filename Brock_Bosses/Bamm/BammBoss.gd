extends Area2D

var canDamage = false
var inRange = false
var immunity = false
var phase = 1
var offsetValue = Vector2(1032,1612)
var healthPhase1 = 10
var healthPhase2 = 10
var phase1Timer = .4
onready var shader = $AnimatedSprite.material
onready var _anim_player = $AnimationPlayer
onready var TweenNode = $Tween
#import random library
var rng = RandomNumberGenerator.new()
#Counter for amount of hits before player heals. This variable will increase by one every time the boss takes damage,
#and and a certain value, the player will heal.
var playerHealthCounter = 0
#Amount of times the player has to hit the boss before they heal. Default is 4.
export var playerHealthValue = 4


onready var proj1 = preload("res://Brock_Bosses/Bamm/BammProjectile.tscn")
onready var proj2 = preload("res://Brock_Bosses/Bamm/BammProjectile3.tscn")
onready var proj3 = preload("res://Brock_Bosses/Bamm/BammProjectile2.tscn")
onready var proj4 = preload("res://Brock_Bosses/Bamm/BammProjectile4.tscn")
onready var proj5 = preload("res://Brock_Bosses/Bamm/BammProjectile5.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	#Starts game with detection range monitoring collision and in idle position
	$DetectionRange/CollisionShape2D.set_deferred("disabled", false)
	_anim_player.play("idle")
	#Randomizes seed for new random play every startup
	rng.randomize()
	SaveAndLoad.room = "res://Brock_Bosses/Bamm/Bamm.tscn"
	SaveAndLoad._Save()

func _process(delta):
	#inRange checks if player is currently colliding with the boss.
	#Immunity checks if the player has been damaged in the last second
	#canDamage checks if after the second of immunity is up if the player is still in hit range
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


func _on_BammBoss_body_entered(body):
	if body.is_in_group("Player"):
		canDamage = true
		inRange = true


func _on_BammBoss_body_exited(body):
	if body.is_in_group("Player"):
		inRange = false

func damage(damage):
	playerHealthCounter += 1
	if playerHealthCounter >= playerHealthValue and Globals.player.health < 5:
		playerHealthCounter = 0
		Globals.player.health += 1
		Globals.player.health_update()
	#If current phase is one, remove health from first health variable. if First health variable is == 0, switch phases
	if phase == 1:
		healthPhase1 -= damage
		shader.set_shader_param("flash_modifier", 1)
		yield(get_tree().create_timer(.07),"timeout")
		shader.set_shader_param("flash_modifier", 0)
		if healthPhase1 == 0:
			phase = 2
	elif phase == 2:
		phase1Timer = 0
		#if phase is 2, and 2nd phase health == 0: queue_free()
		healthPhase2 -= damage
		shader.set_shader_param("flash_modifier", 1)
		yield(get_tree().create_timer(.07),"timeout")
		shader.set_shader_param("flash_modifier", 0)
		if healthPhase2 == 0:
			queue_free()


func _on_DetectionRange_body_entered(body):
	#If player enters the detection area, set detection area monitoring to false.
	#Position the boss to adjust for animation displacement. Play start animation. Wait 2 seconds,
	#and reset position to what it originally was. Reposition to players current position.
	if body.is_in_group("Player"):
		$DetectionRange/CollisionShape2D.set_deferred("disabled",true)
#POSITION CODE FOR START ANIMATION
		position += (Vector2(-49,-50.5))
		_anim_player.play("start")
		yield(get_tree().create_timer(2),"timeout")
		position -= (Vector2(-49,-50.5))
		followPlayer()
#Position for attack 3
#		position += Vector2(-264,0)
#		_anim_player.play("attack3")
#		yield(get_tree().create_timer(1.2),"timeout")
#		position -= Vector2(-264,0)
#		followPlayer()
#POSITION FOR ATTACK 2
#		position += Vector2(-312,16)
#		_anim_player.play("attack2")
#POSITOIN FOR ATTACK 1
#		_anim_player.play("attack1")
#		position += Vector2(304,-20)
#		yield(get_tree().create_timer(1),"timeout")
#		position -= Vector2(304, -20)
#		_anim_player.play("idle")
#		_anim_player.play("attack1 right")
#		position += Vector2(-256, -20)
#		yield(get_tree().create_timer(1),"timeout")
#		_anim_player.play("idle")
#		position -= Vector2(-256, -20)

func _attack():
	#Pick a random number between range(), wait a second to compensate for animations finishing/errors
	#call attack method depending on what number is picked
	var random = rng.randi_range(1,4)
	yield(get_tree().create_timer(.9 + phase1Timer),"timeout")
#	_anim_player.play("idleInvis")
	if random == 1:
		_attack1()
	elif random == 2:
		_attack2()
	elif random == 3:
		_attack3()
	elif random == 4:
		_attack5()
	elif random == 5:
		pass

#Maybe a channeling attack that instances a big projectile on left or right side, boss is in middle
#Attack 5 56, 176
#Maybe attack 5 has different lasers that fire across the screen on different levels
	
func followPlayer():
	#Play blurred idle animation, move current position to where player currently is at start of method call > wait a second
	#(how long that the tween node takes to switch positions +(.1s) to allow for lag/expected error, then play idle positoin with hitbox
	#and finally switch back to attack loop.
	#Checks players position compared to the translation of Node2D in tree(BammBoss areas parent). Without offsetValue the
	#target position would be off by a Vector2 of (1032,1612). The Vector2(0, -215) readjusts the sprite to be in the right height instead
	#of at the players feet.
#	TweenNode.interpolate_property(self,"position", position, ((Globals.player.position - offsetValue) + Vector2(0,-215)),.9,Tween.TRANS_LINEAR,Tween.EASE_IN)
	var followRand = rng.randi_range(1,5)
	if followRand != 5:
		TweenNode.interpolate_property(self,"position", position, (Vector2((Globals.player.position.x - offsetValue.x),0)),.5 + phase1Timer,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
		if $AnimatedSprite.global_position.x - Globals.player.position.x >= 0:
			_anim_player.play("idleBlur")
			yield(get_tree().create_timer(.6 + phase1Timer),"timeout")
	#		_anim_player.play("idlePos2")
		else:
			_anim_player.play("idleBlurRight")
			yield(get_tree().create_timer(.6 + phase1Timer),"timeout")
	#		_anim_player.play("idlePos2Right")
		if $AnimatedSprite.global_position.x - Globals.player.position.x >= 0:
			#Check direction again incase player moved to other side of boss. Allows for more dynamic animations
			_anim_player.play("idlePos2")
		else:
			_anim_player.play("idlePos2Right")
		#Attack after yield statement has run
		_attack()
	else:
		if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 0:
			_anim_player.play("idleBlur")
		else:
			_anim_player.play("idleBlurRight")
#		TweenNode.interpolate_property(self, "position", position, (Globals.player.position - offsetValue + Vector2(0,-550)), .9,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.interpolate_property(self, "position:x", position.x, (Globals.player.position.x - offsetValue.x), .5 + phase1Timer,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.interpolate_property(self, "position:y", position.y, -350, .5 + phase1Timer,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.interpolate_property(self, "scale", scale, Vector2(.7, .7),.5 + phase1Timer,Tween.TRANS_LINEAR,Tween.EASE_IN)
		TweenNode.start()
		yield(get_tree().create_timer(.6 + phase1Timer),"timeout")
		if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 0:
			_anim_player.play("idlePos2")
		else:
			_anim_player.play("idlePos2Right")
#		yield(get_tree().create_timer(1.2),"timeout")
		_attack4()
	
func _attack1():
	#Checks animated sprite position - player position. if positive value, then the player is to the left. Else to the right.
	if $AnimatedSprite.global_position.x - Globals.player.global_position.x <= 0:
		_anim_player.play("attack1")
		"""This yield statement(for both directions) helps prevent sprite from teleporting backward for a split frame. By creating
		a slight time buffer, it allows for the animation to switch to the new animation with offset transformation, then make the transformation"""
		yield(get_tree().create_timer(.03),"timeout")
		#This position is the offset that the animated sprite is relative to the idle position. By adding this Vector2 value, it 
		#starts the animation at the same position the idle animation ended.
		position += Vector2(304,-20)
		yield(get_tree().create_timer(1.3 + phase1Timer),"timeout")
		#This resets the position to what the original one was, allowing for a clean slate and future transformation without complication
		position -= Vector2(304,-20)
		#Method called to relocate idle position to where the player currently is.
		followPlayer()
	else:
		#Same as above, but only called if player is to the left.
		_anim_player.play("attack1 right")
		yield(get_tree().create_timer(.03),"timeout")
		position += Vector2(-256,-20)
		yield(get_tree().create_timer(1.3 + phase1Timer),"timeout")
		position -= Vector2(-256, -20)
		followPlayer()

func _attack2():
	if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 0:
		_anim_player.play("attack2")
		yield(get_tree().create_timer(.03),"timeout")
		position += Vector2(-312, 80)
		TweenNode.interpolate_property(self,"position:x", (position.x + 60), (position.x - 2500),2 + phase1Timer,Tween.TRANS_LINEAR,Tween.EASE_IN,.65)#Make delay 1 second to start after animation finishes
		TweenNode.start()
		yield(get_tree().create_timer(2 + phase1Timer),"timeout")
		position -= Vector2(-312,80)
		followPlayer()
	else:
		_anim_player.play("attack2 right")
		yield(get_tree().create_timer(.03),"timeout")
		position += Vector2(312, 80)
		TweenNode.interpolate_property(self,"position:x", (position.x - 60), (position.x + 2500), 2 + phase1Timer,Tween.TRANS_LINEAR,Tween.EASE_IN,.65)
		TweenNode.start()
		yield(get_tree().create_timer(2 + phase1Timer),"timeout")
		position -= Vector2(312, 80)
		followPlayer()
		
func _attack3():
	if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 0:
		_anim_player.play("attack3maybe")
		yield(get_tree().create_timer(.03),"timeout")
		position += Vector2(-264,0)
		yield(get_tree().create_timer(3.5 + phase1Timer),"timeout")
		position -= Vector2(-264,0)
		followPlayer()
	else:
		_anim_player.play("attack3maybeRight")
		yield(get_tree().create_timer(.03),"timeout")
		position += Vector2(264,0)
		yield(get_tree().create_timer(3.5 + phase1Timer),"timeout")
		position -= Vector2(264,0)
		followPlayer()

func _attack4():
#	yield(get_tree().create_timer(1.2),"timeout")
	if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 0:
		_anim_player.play("attack4 right")
		yield(get_tree().create_timer(.03),"timeout")
		position += Vector2(0, 160)
		yield(get_tree().create_timer(3.5),"timeout")
#		position -= Vector2(0, 354)
#		print("TEST")
	else:
		_anim_player.play("attack4")
		yield(get_tree().create_timer(.03),"timeout")
		position += Vector2(25, 160)
		yield(get_tree().create_timer(3.5),"timeout")
#		print("TEST")
#		position -= Vector2(56, 354)
	scale = Vector2(1,1)
	followPlayer()

func _attack5():
#	if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 0:
	_anim_player.play("attack5")
	position += Vector2(56, 176)
	yield(get_tree().create_timer(1 + phase1Timer),"timeout")
	position -= Vector2(56,176)
	followPlayer()

func followPlayerAir():
	if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 0:
		_anim_player.play("idleBlur")
	else:
		_anim_player.play("idleBlurRight")
	TweenNode.interpolate_property(self, "position", position, (Globals.player.position - offsetValue + Vector2(0,-550)), .9,Tween.TRANS_LINEAR,Tween.EASE_IN)
	TweenNode.interpolate_property(self, "scale", scale, Vector2(.7, .7),.9,Tween.TRANS_LINEAR,Tween.EASE_IN)
	TweenNode.start()
	yield(get_tree().create_timer(1),"timeout")
	if $AnimatedSprite.global_position.x - Globals.player.global_position.x >= 0:
		_anim_player.play("idlePos2")
	else:
		_anim_player.play("idlePos2Right")
	_attack4()

func projectileAttack1():
		var proj = proj1.instance()
		proj.position = position + Vector2(400,250)
		get_parent().add_child(proj)

func projectileAttack2():
	var proj = proj2.instance()
	proj.position = position + Vector2(-400,250)
	get_parent().add_child(proj)

func projectileAttack3():
	var proj = proj3.instance()
	proj.position = position + Vector2(rng.randi_range(-400,0),-450)
	get_parent().add_child(proj)

func projectileAttack4():
	var proj = proj3.instance()
	proj.position = position + Vector2(rng.randi_range(0,400),-450)
	get_parent().add_child(proj)
	
func projectileAttack5():
	var proj = proj4.instance()
	proj.position = position + Vector2(150,0)
	get_parent().add_child(proj)
	var proj2 = proj5.instance()
	proj2.position = position + Vector2(-150,0)
	get_parent().add_child(proj2)
	
	
	
