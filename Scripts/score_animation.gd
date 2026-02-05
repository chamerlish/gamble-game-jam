extends Node2D

var current_night_mode: bool = Global.night
var still_anim: bool = true

func start(added_score: int):
	$BoomParticle.emitting = true
	if Global.score_multiplier > 1:
		$AnimationPlayer.play("play multiplier")
		$MultiplierLabel.text = "x%s" % Global.score_multiplier
	added_score *= Global.score_multiplier - 1
	get_tree().create_timer(2).timeout.connect(func(): still_anim = false)
	for i in (added_score + 1):
		if still_anim:
			$ScoreLabel.text = "+ %s Score" % i
			if current_night_mode != Global.night:
				break
			await get_tree().create_timer(0.001 / Global.score_multiplier * 10).timeout
			if !$ScoreTextSFX.playing:
				$ScoreTextSFX.play()
		
	$ScoreLabel.text = "+ %s Score" % added_score
	await get_tree().create_timer(1).timeout
	queue_free()
