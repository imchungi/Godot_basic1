extends Node2D
@export var pipe_scene : PackedScene


var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200

func _ready() -> void:
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game() -> void:
	#reset variables
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$ScoreLabel.text = "SCORE: " + str(score)
	$GameOver.hide()
	get_tree().call_group("pipes", "queue_free")
	pipes.clear()
	#generate starting pipes
	generate_pipes()
	$bird.reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_running:
		scroll += SCROLL_SPEED
		print(scroll)
		if scroll >= screen_size.x:
			scroll = 0
		#bground\\		
		$Ground.position.x = -scroll	
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED
	

func start_game():
	game_running = true
	$bird.flying = true
	$bird.flap()
	#start pipe timer
	$PipeTimer.start()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false:
					start_game()
				else:
					if $bird.flying:
						$bird.flap()
						check_top()


func _on_pipe_timer_timeout() -> void:
	generate_pipes()
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2  + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)

func scored():
	score += 1
	$ScoreLabel.text = "SCORE: " + str(score)

	
func stop_game():
	$PipeTimer.stop()
	$GameOver.show()
	$bird.flying = false
	game_running = false
	game_over = true
	
func bird_hit():
	$bird.falling = true
	stop_game()
	
func check_top():
	if $bird.position.y<0:
		$bird.falling = true
		stop_game()


func _on_ground_hit() -> void:
	$bird.falling = false
	stop_game() # Replace with function body.


func _on_game_over_restart() -> void:
	new_game()
