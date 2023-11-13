extends Node2D


func _ready():
	pass
	

	
func _on_button_tam_dung_pressed():
	pass




func _on_area_2d_body_entered(body):
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
