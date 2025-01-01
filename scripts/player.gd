extends CharacterBody2D

# Node References
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var duration: Timer = $Movement/Dash/duration

# Actualizable on process variables
var direction_x : int
var direction_y : int
var shift  : bool
var attack : bool

# Variables actualizable on functions
var direction : Vector2
var isDashing : bool = false
var isAttacking

# Constants
const SPEED : float = 100.0
const DASH_SPEED_MULTIPLIER : float = 2.0


# Functions
func _ready() -> void:
	duration.connect("timeout", durationDashTimeout)
	sprite.get_animation

func _physics_process(delta: float) -> void:
	direction_x = Input.get_axis("analog_left", "analog_right")
	direction_y = Input.get_axis("analog_up", "analog_down")
	shift = Input.is_action_just_pressed("shift")
	attack = Input.is_action_just_pressed("attack")

	if not isDashing and not isAttacking:
		walkAction()
		turnDirectionAction()
		if shift:
			dashAction()
		elif attack:
			attackAction()
	elif isDashing:
		velocity = direction.normalized()  * SPEED * DASH_SPEED_MULTIPLIER
	elif isAttacking:
		pass
	
	
	move_and_slide()


func walkAction() -> void:
	if direction_x or direction_y:
		velocity = Vector2(direction_x,direction_y).normalized() * SPEED
		sprite.play("walking")
	if not direction_x:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not direction_y:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	if not isWalking():
		sprite.play("idle")

func turnDirectionAction() -> void:
	if direction_x > 0:
		sprite.flip_h = false
	elif direction_x < 0:
		sprite.flip_h = true

func calculateDirection():
	if isWalking():
		direction = Vector2(direction_x,direction_y)
	else:
		if sprite.flip_h == true:
			direction = Vector2(-1,0)
		else:
			direction = Vector2(1,0)

func isWalking() -> bool:
	return true if velocity != Vector2(0,0) else false

func dashAction() -> void:
	calculateDirection()
	sprite.modulate = "ffffff99"
	duration.start()
	sprite.play("walking")
	sprite.speed_scale = 3
	isDashing = true

func durationDashTimeout() -> void:
	sprite.modulate = "ffffff"
	sprite.speed_scale = 1
	isDashing = false

func attackAction():
	isAttacking = true
	sprite.play("attacking")
