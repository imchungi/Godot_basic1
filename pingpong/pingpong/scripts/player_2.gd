extends StaticBody2D
var paddle_height : int
var ball_pos : Vector2
var dist : int
var move_by : int
var win_height:int
@onready var ballfrom: CharacterBody2D = %Ball


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_height = get_viewport_rect().size.y
	paddle_height = $ColorRect.get_size().y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ball_pos = ballfrom.position
	dist = position.y - ball_pos.y
	
	if abs(dist) > get_parent().PADDLE_SPEED * delta:
		move_by = get_parent().PADDLE_SPEED * delta * (dist / abs(delta))
	else:
		move_by = dist
		
	position.y -= move_by
	position.y = clamp(position.y, paddle_height/2 + 25, win_height - paddle_height / 2 - 25)	
