extends CharacterBody2D

@export var speed := 256
@export var gravity := 1024

func _init() -> void:
	InputMap.add_action("move_left")
	InputMap.add_action("move_right")
	InputMap.add_action("jump")
	map_keycode("move_left", KEY_S)
	map_keycode("move_right", KEY_F)
	map_keycode("jump", KEY_K)

func map_keycode(action: String, keycode: Key) -> void:
	var event = InputEventKey.new()
	event.physical_keycode = keycode
	InputMap.action_add_event(action, event)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta

	velocity.x  = 0
	velocity.x -= speed if Input.is_action_pressed("move_left")  else 0
	velocity.x += speed if Input.is_action_pressed("move_right") else 0

	move_and_slide()

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("jump") and is_on_floor()):
		velocity.y = -512

	if (event.is_action_released("jump") and velocity.y < 0):
		velocity.y = 0
