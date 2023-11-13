extends TileMap
class_name RoomProperties

enum Room {ENTRANCE, NORMAL, REWARD,BOSS,SPECICAL}

@export var level:int
@export var type:int
@export var appeared:bool=false

@export var top:bool=false
@export var bottom:bool=false
@export var left:bool=false
@export var right:bool=false

@export var check_dir:Array=[1,2,3,4]

@export var next_room:TileMap
@export var previous_room:TileMap
@export var mode:bool=false
@export var got_in:bool=false
@export var won:bool=false
@export var number_of_enemies:int
@export var bridge_spawner:Node
@export var enemies:Node2D

func _ready():
	if	type== Room.ENTRANCE:
			set_cell(0,local_to_map(bridge_spawner.get_node("Top").position),-1,Vector2i(-1,-1),-1)
			set_cell(0,local_to_map(bridge_spawner.get_node("Left").position),-1,Vector2i(-1,-1),-1)
			set_cell(0,local_to_map(bridge_spawner.get_node("Right").position),-1,Vector2i(-1,-1),-1)
	elif type==Room.REWARD:
			set_cell(0,local_to_map(bridge_spawner.get_node("Down").position),-1,Vector2i(-1,-1),-1)
			set_cell(0,local_to_map(bridge_spawner.get_node("Top").position),-1,Vector2i(-1,-1),-1)
			set_cell(0,local_to_map(bridge_spawner.get_node("Left").position),-1,Vector2i(-1,-1),-1)
			set_cell(0,local_to_map(bridge_spawner.get_node("Right").position),-1,Vector2i(-1,-1),-1)
	
	else:
		if bottom==true:
			set_cell(0,local_to_map(bridge_spawner.get_node("Down").position),-1,Vector2i(-1,-1),-1)
		if top==true:
			set_cell(0,local_to_map(bridge_spawner.get_node("Top").position),-1,Vector2i(-1,-1),-1)
		if left==true:
			set_cell(0,local_to_map(bridge_spawner.get_node("Left").position),-1,Vector2i(-1,-1),-1)
		if right==true:
			set_cell(0,local_to_map(bridge_spawner.get_node("Right").position),-1,Vector2i(-1,-1),-1)
		

func _process(delta):
	HandleRoom(type)

func HandleRoom(type):
	match type:
		Room.ENTRANCE:
			pass
		Room.NORMAL:
			if won==false:
				number_of_enemies=enemies.get_child_count()
				if number_of_enemies==0:
					number_of_enemies=-1
					won=true
					Win()
		Room.BOSS:
			if won==false:
				number_of_enemies=enemies.get_child_count()
				if number_of_enemies==0:
					number_of_enemies=-1
					won=true
					Win()

func Start():
	if type==Room.BOSS:
		get_node("Enemies/Boss").shoot_timer.start()
	if bottom==true:
		set_cell(0,local_to_map(bridge_spawner.get_node("Down").position),4,Vector2i.ZERO)
	if top==true:
		set_cell(0,local_to_map(bridge_spawner.get_node("Top").position),4,Vector2i.ZERO)
	if left==true:
		set_cell(0,local_to_map(bridge_spawner.get_node("Left").position),4,Vector2i.ZERO)
	if right==true:
		set_cell(0,local_to_map(bridge_spawner.get_node("Right").position),4,Vector2i.ZERO)
	
func Win():
	if type==Room.NORMAL:
		if bottom==true:
			set_cell(0,local_to_map(bridge_spawner.get_node("Down").position),-1,Vector2i(-1,-1),-1)
		if top==true:
			set_cell(0,local_to_map(bridge_spawner.get_node("Top").position),-1,Vector2i(-1,-1),-1)
		if left==true:
			set_cell(0,local_to_map(bridge_spawner.get_node("Left").position),-1,Vector2i(-1,-1),-1)
		if right==true:
			set_cell(0,local_to_map(bridge_spawner.get_node("Right").position),-1,Vector2i(-1,-1),-1)
	elif type==Room.BOSS:
		pass

#Check player is inside the 
func _on_check_get_in_body_entered(body):
	if got_in==false and body.name=="Player":
		got_in=true
		Start()
