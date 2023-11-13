extends Node2D
class_name StateController

enum State {IDlE, MOVING,ATTACKING, ROLLING,SLEEPING,WAKEUP}
@export var allow_change_state:bool=true
@export var cur_state:int
