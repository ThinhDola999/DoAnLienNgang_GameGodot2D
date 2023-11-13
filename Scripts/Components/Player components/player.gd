extends CharacterBody2D

#Components
@onready var gun_to_mouse_vector

@export var _player_animation:AnimationPlayer
@export var _player_sprite:Sprite2D
@export var hand:Node2D
#Gun preb
@export var handle= preload("res://Scenes/weapon.tscn")
@export var weapon:Weapon
@export	var check_left_right=0;
#@onready var gun= get_node("Hand/GunHandle/Gun1")

var gun
#Statistics
var move_speed=100
var state="Moving"

func _ready():
	equipGun()

func _process(delta):
#	Input
	velocity= check_direction();
	var vel=velocity
# 	Check animation
	gun_to_mouse_vector= gun.gun_to_mouse_vector
	animation_controller(vel)
#	print(scale.x," ",gun_to_mouse_vector.x)

#	Movement
	position+=velocity * delta * move_speed
	move_and_slide()
#	move_and_collide(velocity * delta * move_speed)

func equipGun():
	var handle_instance=handle.instantiate()
	hand.add_child(handle_instance)
	gun=handle_instance.get_node("Gun")


func check_direction():
	var velocity= Vector2()
	if Input.is_action_pressed("Move_down"):
		velocity.y+=1;
	if Input.is_action_pressed("Move_up"):
		velocity.y-=1;
	if Input.is_action_pressed("Move_left"):
		velocity.x-=1;
	if Input.is_action_pressed("Move_right"):
		velocity.x+=1;
	velocity= velocity.normalized()
	return velocity;
	
func animation_controller(vel):
#Rotate scale
	if check_left_right==0 and gun_to_mouse_vector.x<-0.5:
#		print(check_left_right," ",gun_to_mouse_vector)
		check_left_right=1
#		print(check_left_right," ",gun_to_mouse_vector, "\n")
		
		scale.x*=-1
	elif check_left_right==1 and gun_to_mouse_vector.x>0.5:
		check_left_right=0;
		scale.x*=-1
		
#Control character animation direction through mouse and velocity
	if state=="Moving" and vel.x!=0 || vel.y!=0:
		if vel.x != 0:
			if gun_to_mouse_vector.y>=0:
				_player_animation.play("Walk_right_front")
			else:
				_player_animation.play("Walk_right_back")
		else:
			if gun_to_mouse_vector.y>0:
				_player_animation.play("Walk_down")
			elif gun_to_mouse_vector.y<0:
				_player_animation.play("Walk_up")
			else:
				_player_animation.play("Idle_down")
	elif vel.x==0 and vel.y==0:
		_player_animation.play("Idle_down")
