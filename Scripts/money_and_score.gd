extends MarginContainer

func _ready() -> void:
	Global.scored.connect(update_score)
	Global.money_changed.connect(update_money)
	Global.no_pos_money_changed.connect(update_money)
	update_score(0, Vector2(0, 0)) # ik ik
	update_money(0, Vector2(0, 0))
	

var base_color: Color = Color(1, 1, 1)

func update_score(added_score, pos):
	$ScoreLabel.text = "Score: %s" % Global.amount_score

func update_money(added_money, pos):
		
	$MoneyLabel.text = "Money: %s" % Global.amount_money
	print(added_money)
	if Global.amount_money < 0:
		base_color = Color(0.9, 0.1, 0.1)
	else:
		base_color = Color(1, 1, 1)
	if added_money > 0:
		$MoneyLabel.modulate = Color(0.2, 0.8, 0.3)
		await get_tree().create_timer(2).timeout
		$MoneyLabel.modulate = base_color
	elif added_money < 0:
		$MoneyLabel.modulate = Color(0.9, 0.1, 0.1)
		await get_tree().create_timer(2).timeout
		$MoneyLabel.modulate = base_color
	
		
