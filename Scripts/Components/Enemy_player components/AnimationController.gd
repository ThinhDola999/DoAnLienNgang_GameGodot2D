extends Sprite2D
class_name AnimationController


@export var detectArea:DetectArea
@export var animator:AnimationPlayer
@export var state:StateController
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	play_loop()

func play_loop():
	match state.cur_state:
		state.State.IDlE:
			animator.play("Idle")
		state.State.MOVING:
			animator.play("Moving")
		state.State.ATTACKING:
			animator.play("Attack")
#		state.State.SLEEPING:
#			animator.play_backwards("WakeUp")

func play_once():
	match state.cur_state:
		state.State.ATTACKING:
			animator.play("Attack")
		state.State.SLEEPING:
			animator.play_backwards("WakeUp")
		state.State.WAKEUP:
			animator.play("WakeUp")
