extends Button


@export var machine_id: int

func _ready() -> void:
	#$Sprite2D.texture = 
	icon = GlobalMachine.get_machine_icon(machine_id)
	
func _on_pressed() -> void:
	GlobalMachine.change_selected_machine(machine_id)
