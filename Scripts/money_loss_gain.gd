extends Control

@onready var money_loss_label = $MoneyLossText
@onready var money_gain_label = $MoneyGainText

func _ready() -> void:
	Global.win_money.connect(win_money)
	Global.loose_money.connect(loose_money)

func loose_money(amount: int, pos):
	global_position = pos
	money_loss_label.text = "- " + str(amount) + " $"
	$AnimationPlayer.play("money_loss")

func win_money(amount: float, pos):
	global_position = pos
	print(pos)
	money_gain_label.text = "+ " + str(amount) + " $"
	$AnimationPlayer.play("money_gain")
