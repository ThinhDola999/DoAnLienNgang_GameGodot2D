extends Node2D
class_name EnemyShoot

@onready var bullet= preload("res://Scenes/bullet_enemy.tscn")

@export var fire_rate:float=2
@export var detect_area:DetectArea
@export var detect_attack:DetectAttack

var lastShoot:float=0
var firetime:float=1/fire_rate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Shoot():
	if detect_area.player_chase==true and detect_attack.player_in_attack_range==false:
		var timeLapsed= Time.get_ticks_msec()/1000
		if timeLapsed>lastShoot + firetime:
			var bullet_instance=bullet.instantiate()
			get_tree().root.add_child(bullet_instance)
			bullet_instance.direction=(detect_area.player.global_position-global_position).normalized()
			bullet_instance.position=global_position
			lastShoot=timeLapsed
	elif detect_area.player_chase==true and detect_attack.player_in_attack_range==true:
		pass
