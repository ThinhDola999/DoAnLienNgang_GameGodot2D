extends Node2D

const bullet_scene = preload("res://Scenes/bullet_enemy.tscn")
@onready var shoot_timer =$Timer
@onready var rotater = $Rotater

const rotate_speed = 800
const shoot_timer_wait_time = 0.05
const spawn_point_count = 4
const radius = 100

func _ready():	
	var step = 2 * PI / spawn_point_count
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shoot_timer_wait_time
#	shoot_timer.start()


func _process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
#	print("new_rotation")

func _on_timer_timeout():
	for s in rotater.get_children():
		var bullet = bullet_scene.instantiate()
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation	
		bullet.direction= Vector2(cos(s.global_rotation), sin(s.global_rotation))
		get_tree().root.add_child(bullet)
