extends Node

signal selected_machine_changed(machine_id: int)

var machine_list: Array[PackedScene] = [
	preload("res://Scenes/Machines/machine1.tscn"),
	preload("res://Scenes/Machines/machine2.tscn"),
	preload("res://Scenes/Machines/machine3.tscn")
]

func change_selected_machine(machine_id: int):
	selected_machine_changed.emit(machine_id)
	
func get_machine_icon(machine_id: int) -> Texture2D:
	return GlobalMachine.machine_list[machine_id].instantiate().get_node("Sprite2D").texture
