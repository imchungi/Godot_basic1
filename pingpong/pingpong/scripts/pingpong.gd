extends Node2D

var  score := [0, 0] # player 1,2
const PADDLE_SPEED : int = 500


func _on_timer_timeout() -> void:
	 # Replace with function body.
	$Ball.new_ball()


func _on_score_left_body_entered(body: Node2D) -> void:
	score[1] += 1
	$Hud/player2.text = str(score[1])
	$Timer.start()
func _on_score_right_body_entered(body: Node2D) -> void:
	score[0] += 1
	$Hud/player1.text = str(score[0])
	$Timer.start()
