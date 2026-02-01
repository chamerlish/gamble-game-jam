extends Node2D

func start(added_score: int):
	print(Global.score_multiplier)
	if Global.score_multiplier > 1:
		$AnimationPlayer.play("play multiplier")
		$MultiplierLabel.text = "x%s" % Global.score_multiplier
	Global.score_multiplier += 0.5
	print($MultiplierLabel.text)
	added_score *= Global.score_multiplier
	for i in added_score + 1:
		$ScoreLabel.text = "+ %s Score" % i
		await get_tree().create_timer(0.01).timeout
		if !$ScoreTextSFX.playing:
			$ScoreTextSFX.play()
		
	await get_tree().create_timer(1).timeout
	queue_free()
