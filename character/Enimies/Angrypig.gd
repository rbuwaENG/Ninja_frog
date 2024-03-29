extends KinematicBody2D

enum STATE {WALK,RUN}


export(float) var walk_speed = 100
export(float) var run_speed = 200
export(float) var waypoint_arrived_distance = 10
export(Array,NodePath) var waypoints
export(int) var starting_waypoint = 0
export(bool) var face_right = true
var velocity = Vector2.ZERO
var current_state = STATE.WALK 

var waypoint_position 
var waypoint_index setget set_waypoint_index
onready var animated_sprite =$AnimatedSprite
onready var animation_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	self.waypoint_index =  starting_waypoint

func _physics_process(delta):
	var direction = self.position.direction_to(waypoint_position)
	var distance_x = Vector2(self.position.x,0).distance_to(Vector2(waypoint_position.x,0))
	
	if(distance_x >= waypoint_arrived_distance):
		var direction_x_sign = sign(direction.x)
		var move_speed : float
		
		match(current_state):
			STATE.WALK:
				move_speed = walk_speed
			STATE.RUN:
				move_speed = run_speed
				
		
		
		velocity = Vector2 (
			move_speed*direction_x_sign,
			min(velocity.y + GemeSettings.gravity,GemeSettings.terminal_velocity)
			)
		if(direction_x_sign == -1):
			animated_sprite.flip_h = face_right
		elif(direction_x_sign == 1):
			animated_sprite.flip_h = !face_right
		
		move_and_slide(velocity,Vector2.UP)
	
	else:
		var num_waypoints = waypoints.size()
		
		if (waypoint_index < num_waypoints-1):
			self.waypoint_index += 1
		else:
			self.waypoint_index = 0
		
	
func set_waypoint_index(value):
	waypoint_index = value 
	waypoint_position = get_node(waypoints[value]).position


func _on_Area2D_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	animation_tree.set("parameters/player_detected/blend_position",1)
	current_state = STATE.RUN
	


func _on_Area2D_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	animation_tree.set("parameters/player_detected/blend_position",0)
	current_state = STATE.WALK
