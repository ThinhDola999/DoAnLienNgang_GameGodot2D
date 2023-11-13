extends Node2D

var menuSetting
var scene_change_timer
var sfx
@export var HomeScene: PackedScene

func _ready():
	sfx = $sfx
	scene_change_timer = $Timer
	menuSetting = $menuSetting
	menuSetting.hide()

func _on_button_caidat_pressed():
	sfx.play()
	if menuSetting.is_visible():
		menuSetting.hide()
	else:
		menuSetting.show()


func _on_button_play_game_button_up():
	sfx.play()
	scene_change_timer.start() 
	


func _on_timer_timeout():
	get_tree().change_scene_to_packed(HomeScene)
