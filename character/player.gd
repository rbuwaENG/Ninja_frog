extends KinematicBody2D

export(float)var move_speed = 200
export(float)var jump_impulse = 600
export(float)var max_jumps = 2

signal changed_state(new_state_str,new_state)

var velocity : Vector2

enum STATE {IDLE,RUN,JUMP,DOUBLE_JUMP}
var current_state = STATE.IDLE setget set_current_state
var jumps = 0
onready var animation_tree = $AnimationTree
onready var animation_sprite = $AnimatedSprite


func _physics_process(delta):
	var input = get_player_input()
	adiust_flip_direction(input)
	velocity = Vector2(
		input.x *move_speed,
		min(velocity.y + GemeSettings.gravity,GemeSettings.terminal_velocity)
	)
	
	velocity = move_and_slide(velocity,Vector2.UP)
	
	pick_next_state()
	set_animation_parameter()

func adiust_flip_direction(input : Vector2):
	if(sign(velocity.x)==1):
		animation_sprite.flip_h = false
	elif(sign(velocity.x) == -1):
		animation_sprite.flip_h = true
	
func set_animation_parameter():
	animation_tree.set("parameters/x_sign/blend_position",sign(velocity.x))
	animation_tree.set("parameters/y_sign/blend_amount",sign(velocity.y))
	
func pick_next_state():
	if(is_on_floor()):
		jumps = 0
		
		if(Input.is_action_just_pressed("jump")):
			self.current_state = STATE.JUMP
			
		elif(abs(velocity.x)>0):
			self.current_state = STATE.RUN
		else:
			self.current_state = STATE.IDLE
	else:
		if (Input.is_action_just_pressed("jump") && (jumps < max_jumps)):
			self.current_state = STATE.DOUBLE_JUMP
			
	
func get_player_input():
	var input : Vector2
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_up")
	
	return input

func Jump():
	velocity.y = -jump_impulse
	jumps += 1
	print(jumps)

#STTERS
func set_current_state(new_state):
	match(new_state):
		STATE.JUMP:
			Jump()
		STATE.DOUBLE_JUMP:
			Jump()
			animation_tree.set("parameters/double_jump/active",true)
	current_state = new_state
	emit_signal("changed_state",STATE.keys()[new_state],new_state)



