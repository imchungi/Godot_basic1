extends CharacterBody2D

@export var speed = 300.0
@export var junp_velocity = -400.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	
	basic_movement(delta)
	handle_animation()
	handle_direction()
	move_and_slide()

func handle_animation() -> void:
	if is_on_floor():
		if velocity:
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("default")
	else:
		if velocity.y < 0 :
			animated_sprite_2d.play("jump")
		else:
			animated_sprite_2d.play("glide")
	
			
func handle_direction() -> void:
	if velocity.x <0 :
		animated_sprite_2d.scale.x = -1
	elif velocity.x > 0 :
		animated_sprite_2d.scale.x = 1
	#animated_sprite_2d.flip_h = false #center point missed
	
func basic_movement(delta: float)-> void:
		# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = junp_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
