extends Node2D

enum Room {ENTRANCE, NORMAL, REWARD,BOSS,SPECICAL}

var entrance=preload("res://Scenes/Entrance.tscn")
var normals:Array = [preload("res://Scenes/map.tscn"),preload("res://Scenes/map2.tscn"),preload("res://Scenes/map3.tscn"),preload("res://Scenes/map4.tscn"),preload("res://Scenes/map5.tscn"),preload("res://Scenes/map.tscn")]
var specials:Array = [preload("res://Scenes/map.tscn")]
var bosses:Array = [preload("res://Scenes/boss_map.tscn")]
var rewards:Array = [preload("res://Scenes/reward.tscn"),preload("res://Scenes/reward.tscn")]
var rooms:Node2D
var cur_tile_map:TileMap
var pre_tile_map:TileMap

const tile_size:int=16
const bridge_size=5

@export var number_of_rooms:int

#rooms 
var rooms_list:Array=[Room.ENTRANCE,Room.NORMAL,Room.NORMAL,Room.NORMAL,Room.REWARD,Room.NORMAL,Room.NORMAL,Room.NORMAL,Room.REWARD,Room.BOSS]
#var rooms_tree:Array =[[0,1],[1,2],[1,3],[2,4],[3,5],[4,5],[5,6],[6,7],[6,8],[7,8],[8,9]]
var rooms_tree:Array =[[0,1],[1,2],[1,3],[2,4],[3,5],[5,6],[6,7],[6,8],[8,9]]
#var rooms_tree:Array =[[0,1],[1,2],[1,3]]
var tile_maps:Array

func _ready() -> void:
	rooms=get_node("Rooms")
	Spawn_entrance()
	Spawn_rooms()

func Spawn_entrance():
	var entrance_pref= entrance.instantiate()
	cur_tile_map=entrance_pref
	rooms.add_child(cur_tile_map)
	tile_maps.push_back(cur_tile_map)
	cur_tile_map.check_dir.erase(4)

func Make_path(dir):
	match dir:
		1:
			for i in bridge_size:
				cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Left").position)+Vector2i(-i,-1),4,Vector2i.ZERO);
				cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Left").position)+Vector2i(-i,0),3,Vector2i(9,3));
				cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Left").position)+Vector2i(-i,1),4,Vector2i.ZERO);
		2:
			for i in bridge_size:
				cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Top").position)+Vector2i(-1,-i),4,Vector2i.ZERO);
				cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Top").position)+Vector2i(0,-i),3,Vector2i(10,2));
				cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Top").position)+Vector2i(1,-i),4,Vector2i.ZERO);
		3:
			for i in bridge_size:
				cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Right").position)+Vector2i(i,-1),4,Vector2i.ZERO);
				cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Right").position)+Vector2i(i,0),3,Vector2i(9,3));
				cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Right").position)+Vector2i(i,1),4,Vector2i.ZERO);
		4:
			for i in bridge_size:
				cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Down").position)+Vector2i(-1,i),4,Vector2i.ZERO);
				cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Down").position)+Vector2i(0,i),3,Vector2i(10,2));
				cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Down").position)+Vector2i(1,i),4,Vector2i.ZERO);
	
func Make_room(dir, type):
#Instance random room
	var random_room=null
	pre_tile_map=cur_tile_map
	var room_pref
	match type:
			Room.NORMAL:
				if normals.size()>0:
					random_room= normals.pick_random()
					normals.erase(random_room)
			Room.SPECICAL:
				if specials.size()>0:
					random_room= specials.pick_random()
					specials.erase(random_room)
			Room.BOSS:
				if bosses.size()>0:
					random_room= bosses.pick_random()
					bosses.erase(random_room)
			Room.REWARD:
				if rewards.size()>0:
					random_room= rewards.pick_random()
					rewards.erase(random_room)
					
	if random_room!=null:
		room_pref= random_room.instantiate()
		Make_path(dir)
	else:
		return
	cur_tile_map=room_pref
	if tile_maps.find(cur_tile_map,0)==-1:
		tile_maps.push_back(cur_tile_map)

	
#Create
	match dir:
		1:
			cur_tile_map.right=true
			cur_tile_map.position=pre_tile_map.position+ Vector2.LEFT*tile_size*(bridge_size+25)
			rooms.add_child(cur_tile_map)
			cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Right").position),3,Vector2i(9,3));
			cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Right").position),-1,Vector2i(-1,-1),-1);
			cur_tile_map.check_dir.erase(3)					
		2:
			cur_tile_map.bottom=true
			cur_tile_map.position=pre_tile_map.position+ Vector2.UP*tile_size*(bridge_size+25)
			rooms.add_child(cur_tile_map)
			cur_tile_map.check_dir.erase(4)		
			cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Down").position),3,Vector2i(10,2));
			cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Down").position)+Vector2i(0,1),3,Vector2i(10,2));
			cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Down").position)+Vector2i(0,2),3,Vector2i(10,2));
		3:
			cur_tile_map.left=true
			cur_tile_map.position=pre_tile_map.position+ Vector2.RIGHT*tile_size*(bridge_size+25)
			rooms.add_child(cur_tile_map)
			cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Left").position),3,Vector2i(9,3));
			cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Left").position),-1,Vector2i(-1,-1),-1);
			cur_tile_map.check_dir.erase(1)		
		4:
			cur_tile_map.top=true
			cur_tile_map.position=pre_tile_map.position+ Vector2.DOWN*tile_size*(bridge_size+25)
			rooms.add_child(cur_tile_map)
			cur_tile_map.check_dir.erase(2)		
			cur_tile_map.set_cell(4,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Top").position),3,Vector2i(10,2));
			cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Top").position),-1,Vector2i(-1,-1),-1);

func Spawn_rooms():
	for i in rooms_tree:
#Random direction
		var my_random_number
		cur_tile_map=tile_maps[i[0]]
		my_random_number=cur_tile_map.check_dir.pick_random()
		cur_tile_map.check_dir.erase(my_random_number)
#Create
		match my_random_number:
			1:
				cur_tile_map.left=true
				if cur_tile_map.type==Room.ENTRANCE:
					cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Top").position),4,Vector2i.ZERO)
					cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Right").position),4,Vector2i.ZERO)
				Make_room(1,rooms_list[i[1]])
			2:
				cur_tile_map.top=true
				if cur_tile_map.type==Room.ENTRANCE:
					cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Left").position),4,Vector2i.ZERO)
					cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Right").position),4,Vector2i.ZERO)
				Make_room(2,rooms_list[i[1]])
			3:
				cur_tile_map.right=true
				if cur_tile_map.type==Room.ENTRANCE:
					cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Top").position),4,Vector2i.ZERO)
					cur_tile_map.set_cell(0,cur_tile_map.local_to_map(cur_tile_map.bridge_spawner.get_node("Left").position),4,Vector2i.ZERO)
				Make_room(3,rooms_list[i[1]])
			4:
				cur_tile_map.bottom=true
				Make_room(4,rooms_list[i[1]])
#		break;
