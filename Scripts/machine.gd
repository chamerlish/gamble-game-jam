extends StaticBody2D


class_name Machine


@export var placed: bool

@onready var collision: CollisionPolygon2D = $CollisionPolygon2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var panel_tweak: Panel = $HUD/Panel


@export var texture: CompressedTexture2D
@export var machine_name: String
@export var odds_of_winning: float = 0.1
@export var prize_money: int = 100
@export var price: int = 100

@onready var roll_sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

# for the panel cuz when you drop it first it counts as drop
var nums_of_clicks: int 

var isDraggin: bool


var available = true
var mouse_inside := false

var broken = false



func _ready() -> void:
	panel_tweak.hide()
	# TODO: fix this
	texture = $Sprite2D.texture
	GlobalMachine.all_machines_list.append(self)


func _process(delta: float) -> void:
	#print("available", available)
	#print("broken:", broken)
	if mouse_inside:
		nums_of_clicks += 1
		if Input.is_action_just_pressed("click") and nums_of_clicks > 0:
			panel_tweak.show()
	
	else:
		panel_tweak.hide()
	
	$HUD/Panel/ProgressBar.value = $HUD/Panel/Slider.value
	z_index = GlobalMachine.get_entity_z(self)
	
	if Input.is_action_pressed("click") and not placed:
		placable_mode()
		
	if placed == false:
		available = false
		
	

func _input(event: InputEvent) -> void:
	if event.is_action_released("click") and not placed:
		place_machine()
		
func placable_mode():
	var mouse_pos = get_global_mouse_position().snapped(Global.TILE_SIZE)
	
	collision.disabled = true
	sprite.modulate.a = 0.5
	
	global_position = mouse_pos
	
func place_machine():
	placed = true
	available = true
	collision.disabled = false
	sprite.modulate.a = 1
	Global.camera_node.trigger_shake()
	GlobalMachine.placed_machine_list.append(self)
	GlobalMachine.available_machine_list.append(self)
	loose_money(price)


@onready var money_loss_label = $HUD/MouseFollow/MoneyLossText
@onready var money_gain_label = $HUD/MouseFollow/MoneyGainText

func loose_money(amount: int):
	$HUD/MouseFollow.global_position = get_global_mouse_position()
	money_loss_label.text = "- " + str(amount) + " $"
	$AnimationPlayer.play("money_loss")

func win_money(amount: float):
	$HUD/MouseFollow.global_position = get_global_mouse_position()
	money_gain_label.text = "+ " + str(amount) + " $"
	$AnimationPlayer.play("money_gain")


#func _on_mouse_tweak_area_mouse_entered() -> void:
#	mouse_inside = true


#func _on_mouse_tweak_area_mouse_exited() -> void:
#	mouse_inside = false


#func _on_slider_drag_ended(value_changed: bool) -> void:
#	odds_of_winning = panel_tweak.get_node("Slider").value / 100

func break_machine():
	broken = true
	available = false
	GlobalMachine.available_machine_list.erase(self)
	modulate.b=1
	print("broookennn")
	
func play_sfx():
	if roll_sfx:
		roll_sfx.play()
