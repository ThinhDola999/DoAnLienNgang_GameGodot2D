extends Area2D
class_name DetectAttack

@export var player_in_attack_range=false
@export var player:CharacterBody2D

func _process(delta):
#	print(player_chase)
	pass

func _on_body_entered(body):
	if body.name=="Player":
		player=body
		player_in_attack_range=true



func _on_body_exited(body):
	player_in_attack_range=false
	player=null

