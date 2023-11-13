extends CharacterBody2D


@export var statistics:StatisticsComponent
@export var detect_area:DetectArea
@export var detect_attack:DetectAttack
@export var attack:AttackComponent
@export var enemyShoot:EnemyShoot
@export var close_range_attack:CloseRangedAttack
@export var navAgent:NavigationAgent2D
@export var state:StateController
@export var timer:Timer
@export var animation_controller:AnimationController
@export var sprite:Sprite2D
@export var acel=7

@export var last_attack_time:float
@export var t:float=0
var x
var y
var check_left_right=1

#Test variable
@export var detect_area_collision:CollisionShape2D
var sleep_once:bool=true
var wakeup_once:bool=false
var awake_time:float

func _ready():
	state.cur_state=state.State.IDlE
	last_attack_time=0
	
#func _process(delta):
#	if detectArea.player_chase==true:
#		makepath()
	
func _physics_process(delta):
	pass
#	if timerState.is_stopped():
#		state.cur_state=state.State.SLEEPING

	if timer.is_stopped():
		state.allow_change_state=true
#		print(statistics.enemy_type)
	#Check enemy type
	match statistics.enemy_type:
		0:
			#Flip direction
			if velocity.x<0 and check_left_right==0:
				check_left_right=1
				scale.x*=-1
			elif velocity.x>0 and check_left_right==1:
				check_left_right=0
				scale.x*=-1
			PhysicsMovement(delta)
		1:
			if detect_area.player_chase==true:
				if (detect_area.player.global_position-global_position).x<0 and check_left_right==0:
					check_left_right=1
					scale.x*=-1
				elif (detect_area.player.global_position-global_position).x>0 and check_left_right==1:
					check_left_right=0
					scale.x*=-1
			UnphysicsMovement(delta)
		2:
			#Flip direction
			if velocity.x<0 and check_left_right==0:
				check_left_right=1
				scale.x*=-1
			elif velocity.x>0 and check_left_right==1:
				check_left_right=0
				scale.x*=-1
				
			if statistics.health<= statistics.max_health/2 and sleep_once==true:
				var timeLapsed= Time.get_ticks_msec()/1000
				awake_time=timeLapsed+3
				sleep_once=false
				state.cur_state=state.State.SLEEPING
				wakeup_once=true;
				
			if awake_time>0 and Time.get_ticks_msec()/1000<=awake_time:
				sprite.modulate=Color.GREEN
				await get_tree().create_timer(0.1).timeout
				sprite.modulate=Color.WHITE
			else:
				if wakeup_once==true:
					detect_area_collision.shape.radius = 250
					sprite.modulate=Color.RED
					state.cur_state=state.State.WAKEUP
					animation_controller.play_once()
					statistics.health+=250
					statistics.atk_damage*=2
					statistics.atk_speed/=2
					statistics.speed*=1.5
					wakeup_once=false
				else:
					ChangeState(delta)
			ActionsControllerBear(delta)
			
		
func UnphysicsMovement(delta):
	
#Check outside range
	if detect_area.player_chase==false and detect_attack.player_in_attack_range==false and (state.cur_state==state.State.IDlE or (state.cur_state!=state.State.IDlE and state.allow_change_state==true)):
		state.cur_state=state.State.IDlE
		t+=0.01
		var f = 2 / (3 - cos(2*t))
		x = f * cos(t)
		y = f * sin(2*t) / 2
		var vector=Vector2(x,y).normalized()
		position+=vector*statistics.speed*delta
# Check detect player range
	elif detect_area.player_chase==true and detect_attack.player_in_attack_range==false and (state.cur_state==state.State.MOVING or (state.cur_state!=state.State.MOVING and state.allow_change_state==true)):
		state.cur_state=state.State.MOVING
		enemyShoot.Shoot()
# Check in attack range
	elif detect_attack.player_in_attack_range==true and state.allow_change_state==true:
		state.cur_state=state.State.ATTACKING
		timer.start()
		state.allow_change_state=false
		close_range_attack.Attack(delta)
		
func PhysicsMovement(delta):
	#Move this enemy to player using navagent
#	print(detect_area.player)
	if detect_area.player_chase==true:
		state.cur_state=state.State.MOVING
		navAgent.set_target_position(detect_area.player.global_position)
		var dir=navAgent.get_next_path_position()- global_position
#		dir=dir.normalized()
		velocity=velocity.lerp(dir*statistics.speed*delta, acel*delta)
#		print(velocity )
		move_and_slide()
	else:
		state.cur_state=state.State.IDlE
	pass
	
func ChangeState(delta):
	if detect_area.player_chase==false and detect_attack.player_in_attack_range==false and state.cur_state!=state.State.IDlE :
		state.cur_state=state.State.IDlE
	elif detect_area.player_chase==true and detect_attack.player_in_attack_range==false and state.cur_state!=state.State.MOVING :
		state.cur_state=state.State.MOVING
	elif detect_attack.player_in_attack_range==true and state.cur_state!=state.State.ATTACKING:
		state.cur_state=state.State.ATTACKING

func ActionsControllerBear(delta):
	match state.cur_state:
		state.State.IDlE:
			pass
		state.State.MOVING:
			navAgent.set_target_position(detect_area.player.global_position)
			var dir=navAgent.get_next_path_position()- global_position
	#		dir=dir.normalized()
			velocity=velocity.lerp(dir*statistics.speed*delta, acel*delta)
	#		print(velocity )
			move_and_slide()
		state.State.ATTACKING:
			var timeLapsed= Time.get_ticks_msec()/1000
#			print(timeLapsed," ",last_attack_time+statistics.atk_speed)
			if timeLapsed>last_attack_time+statistics.atk_speed:
				animation_controller.play_once()
				last_attack_time=timeLapsed
		state.State.SLEEPING:
			animation_controller.play_once()
			


