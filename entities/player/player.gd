extends CharacterBody2D

@export var speed := 200
@export var gravity := 2000
@export var jump_force := 500

var animation_lock = 0

var attacking = false

func _init() -> void:
	InputMap.add_action("attack")
	InputMap.add_action("jump")
	InputMap.add_action("move_left")
	InputMap.add_action("move_right")
	map_keycode("attack", KEY_SPACE)
	map_keycode("jump", KEY_K)
	map_keycode("move_left", KEY_S)
	map_keycode("move_right", KEY_F)

func _ready() -> void:
	$AnimatedSprite2D.play("idle")

func map_keycode(action: String, keycode: Key) -> void:
	var event = InputEventKey.new()
	event.physical_keycode = keycode
	InputMap.action_add_event(action, event)

func _process(delta: float) -> void:
	animation_lock = max(0, animation_lock - delta)

	if (velocity.x < 0):
		$AnimatedSprite2D.flip_h = true;

	if (velocity.x > 0):
		$AnimatedSprite2D.flip_h = false;

	if (velocity.y < 0):
		$AnimatedSprite2D.play("jump")
	elif (velocity.y > 0):
		$AnimatedSprite2D.play("fall")
	elif (velocity.x != 0):
		$AnimatedSprite2D.play("run")
	elif (animation_lock == 0):
		$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta

	velocity.x  = 0
	velocity.x -= speed if Input.is_action_pressed("move_left")  else 0
	velocity.x += speed if Input.is_action_pressed("move_right") else 0
	velocity.x  = 0.0 if animation_lock else velocity.x

	move_and_slide()

func _input(event: InputEvent) -> void:
	if (animation_lock):
		return

	if (event.is_action_pressed("jump") and is_on_floor()):
		velocity.y = -jump_force

	if (event.is_action_released("jump") and velocity.y < 0):
		velocity.y = 0

	if (event.is_action_pressed("attack") and is_on_floor()):
		$AnimatedSprite2D.play("attack")
		animation_lock = 0.33
