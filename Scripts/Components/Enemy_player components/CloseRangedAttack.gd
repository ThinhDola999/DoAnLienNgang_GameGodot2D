extends Node2D
class_name CloseRangedAttack

@export var statisticsComponent:StatisticsComponent
@export var detect_attack:DetectAttack
@export var state:StateController

var vector_attack:Vector2
func _process(delta):
	if state.cur_state==state.State.ATTACKING:
		get_parent().position+=vector_attack*(statisticsComponent.speed*1.5)*delta
		
func Attack(delta):
	match statisticsComponent.enemy_type:
		0:
			pass
		1:
			FlyingAttack(delta)


func FlyingAttack(delta):
	vector_attack= (detect_attack.player.global_position- global_position).normalized()
	print("Attacking")
