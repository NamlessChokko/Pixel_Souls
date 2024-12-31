extends CharacterBody2D


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var duration: Timer = $Dash/duration

var isDashing : bool = false
var direction : Vector2

const SPEED : float = 100.0
const DASH_SPEED_MULTIPLIER : float = 2.0

func _ready() -> void:
	duration.connect("timeout", durationTimeout)

func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("analog_left", "analog_right")
	var direction_y := Input.get_axis("analog_up", "analog_down")
	var shift : bool = Input.is_action_just_pressed("shift")
	
	if not isDashing:
		walkAction(direction_x, direction_y)
		turnDirectionAction(direction_x)
		
		if shift:
			dashAction(direction_x,direction_y)
			
	else:
		velocity = direction.normalized()  * SPEED * DASH_SPEED_MULTIPLIER

	
	move_and_slide()

func walkAction(dir_x : float,dir_y : float) -> void:
	if dir_x or dir_y:
		velocity = Vector2(dir_x,dir_y).normalized() * SPEED
		sprite.play("walking")
	if not dir_x:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not dir_y:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if not isWalking():
		sprite.play("idle")

func turnDirectionAction(dir_x : float) -> void:
	if dir_x > 0:
		sprite.flip_h = false
	elif dir_x < 0:
		sprite.flip_h = true

func changeDashDirection(dir_x : int,dir_y : int):
	if isWalking():
		direction = Vector2(dir_x,dir_y)
	else:
		if sprite.flip_h == true:
			direction = Vector2(-1,0)
		else:
			direction = Vector2(1,0)

func dashAction(dir_x : int, dir_y : int) -> void:
	changeDashDirection(dir_x,dir_y)
	sprite.modulate = "ffffff99"
	duration.start()
	sprite.play("walking")
	sprite.speed_scale = 3
	isDashing = true
	

func isWalking() -> bool:
	return true if velocity != Vector2(0,0) else false

func durationTimeout() -> void:
	sprite.modulate = "ffffff"
	sprite.speed_scale = 1
	isDashing = false
