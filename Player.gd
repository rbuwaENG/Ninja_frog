extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var curHP : int = 10 #current HP
var maxHP : int = 10 
var moveSpeed : int = 250
var damage : int = 1

var gold : int = 0

var curLevel : int = 0
var curXP : int = 0
var xpToNextLevel : int = 50
var xpToNextLevelIncreaseRate : float = 1.2

var interactDist : int = 70

var vel = Vector2() #velocity vector
var facingDir = Vector2() #vector for the facing direction

onready var rayCast = $RayCast2D
# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	vel = Vector2()
	
	#Flipping the main character
	if facingDir == Vector2(-1,0):
		$Sprite.flip_h = true
	elif facingDir == Vector2(1,0):
		$Sprite.flip_h = false
	
	#inputs
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
		facingDir = Vector2(0,-1)

	if Input.is_action_pressed("move_down"):
		vel.y += 1
		facingDir = Vector2(0,1)

	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		facingDir = Vector2(-1,0)

	if Input.is_action_pressed("move_right"):
		vel.x += 1
		facingDir = Vector2(1,0)

	#normalize the velocity to prevent faster diagonal movement
	vel = vel.normalized()
	
	#move the player
	move_and_slide(vel * moveSpeed, Vector2.ZERO)
	
	#call animations
	manage_animations()
	
func manage_animations ():
	if vel.x != 0 or vel.y != 0:
		$AnimationPlayer.play("Walk")
	elif vel.x == 0 or vel.y == 0:
		$AnimationPlayer.play("Idle")
		
		
	
