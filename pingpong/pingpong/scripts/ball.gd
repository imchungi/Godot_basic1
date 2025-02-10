extends CharacterBody2D

var win_size : Vector2
const START_SPEED :int = 500
const ACCEL : int = 50
var speed : int
var dir : Vector2

const MAX_Y_VECTOR : float = 0.4


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_size = get_viewport_rect().size - Vector2(0,50)
	
	
func new_ball():
	position.x = win_size.x/2
	position.y = randi_range(200, win_size.y - 200)
	speed = START_SPEED
	dir = random_direction()

func  random_direction():
	var new_dir = Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed *delta)
	var collider
	if collision:
		collider  = collision.get_collider()
		if collider == $"../player1"or collider == $"../player2" :
			speed += ACCEL
			#dir = dir.bounce(collision.get_normal())
			dir = new_direction(collider)
		else:#wall
			dir = dir.bounce(collision.get_normal())
			
#팅기는 각도 변화주기
func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	if dir.x > 0:
		new_dir.x = -1
	else :
		new_dir.x = 1
	new_dir.y = (dist/ (collider.paddle_height /2)) * MAX_Y_VECTOR
	
	return new_dir.normalized()
	
	
