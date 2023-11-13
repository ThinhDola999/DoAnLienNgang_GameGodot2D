extends Area2D
class_name AttackComponent

@export var statistics:StatisticsComponent

func _on_area_entered(area):
	if area is HitComponent and area.get_parent().name=="Player":
		area.damage(statistics.atk_damage)
	pass


func _on_body_entered(body):
	pass # Replace with function body.
