extends Area2D


func _on_body_entered(body):
	if body.name=="Player":
		body.get_node("HitComponent").healall()
		queue_free()
