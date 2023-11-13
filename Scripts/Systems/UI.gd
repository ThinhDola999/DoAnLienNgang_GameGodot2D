extends CanvasLayer


func _on_button_tam_dung_pressed():
#	$sfx.play()
	get_tree().paused = true
	$menu_tam_dung.show()
	$menuSetting.hide()
