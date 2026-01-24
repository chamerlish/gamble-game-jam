extends Node

signal selected_machine_changed(machine_id: int)

var machine_list: Array[PackedScene] = [
	preload("res://Scenes/Machines/machine1.tscn"),
	preload("res://Scenes/Machines/machine2.tscn"),
	preload("res://Scenes/Machines/machine3.tscn")
]

var entity_list: Array[Node2D]

var placed_machine_list: Array[Machine] = []

func change_selected_machine(machine_id: int):
	selected_machine_changed.emit(machine_id)
	
func get_machine_icon(machine_id: int) -> Texture2D:
	return GlobalMachine.machine_list[machine_id].instantiate().get_node("Sprite2D").texture


func get_entity_z(entity: Node2D) -> int:
	entity_list = []
	for machine in placed_machine_list:
		entity_list.append(machine)
	
	entity_list.append(Global.player_node)
	
	sort_y_placed_machine(entity_list)
	
#	if machine.position.y < Global.player_node.position.y:
#		var i = placed_machine_list.size() - 1
#		# Scheming through all the elements bigger than our machine y
#		while i < placed_machine_list.find(machine):
#			placed_machine_list[i].z_index = 
#			i -= 1
		
	return entity_list.find(entity)


# biggest to smallest
func sort_y_placed_machine(list):
	list.sort_custom(func(a, b): return a.position.y < b.position.y)
