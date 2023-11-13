extends Area2D
class_name DetectArea

@export var player_chase=false
@export var player:CharacterBody2D

func _process(delta):
#	print(player_chase)
	pass

func _on_body_entered(body):
	if body.name=="Player":
		player=body
		player_chase=true



func _on_body_exited(body):
	if body.name=="Player":
		player_chase=false
		player=null


func _on_area_entered(area):
#	print(area)
	pass
