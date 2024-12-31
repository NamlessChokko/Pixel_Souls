extends CharacterBody2D


@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var duration: Timer = $Dash/duration

const SPEED : float = 100.0
const DASH_SPEED_MULTIPLIER : float = 2.0

var isDashing : bool = false
var isAttacking : bool = false
var isBlocking : bool = false

func _ready() -> void:
	duration.connect("timeout", durationTimeout)

func _physics_process(delta: float) -> void:

	# Combat variables:
	var attack : bool = Input.is_action_just_pressed("attack")
	var block : bool = Input.is_action_just_pressed("block")

	# Movement variables:
	var direction_x := Input.get_axis("analog_left", "analog_right")
	var direction_y := Input.get_axis("analog_up", "analog_down")
	var shift : bool = Input.is_action_just_pressed("shift")

#================================================================================#

	# Movement Actions:
	
	if not isAttacking and not isBlocking:
		movement(direction_x, direction_y, shift)
	else:
		if isAttacking:
			attackAction()
		if isBlocking:
			blockAction()
	

	
	


# Defining function: 

func movement (direction_x, direction_y, shift) -> void:
	if not isDashing:
		walkAction(direction_x, direction_y)
		turnDirectionAction(direction_x)
		
		if shift:
			dashAction()
			
	else:
		print(duration.time_left)
		velocity.x = SPEED * DASH_SPEED_MULTIPLIER

	move_and_slide()
	

func walkAction(dir_x : float,dir_y : float) -> void:
	if not isWalking():
		sprite.play("idle")
		return
	if dir_x or dir_y:
		velocity = Vector2(dir_x,dir_y).normalized() * SPEED
		sprite.play("walking")
	if not dir_x:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not dir_y:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	

func turnDirectionAction(dir_x : float) -> void:
	if dir_x > 0:
		sprite.flip_h = false
	elif dir_x < 0:
		sprite.flip_h = true

func isWalking() -> bool:
	return true if velocity != Vector2(0,0) else false


func dashAction() -> void:
	sprite.modulate = "ffffff99"
	duration.start()
	sprite.play("walking")
	sprite.speed_scale = 3
	isDashing = true
	
func durationTimeout() -> void:
	sprite.modulate = "ffffff"
	sprite.speed_scale = 1
	isDashing = false


func attackAction() -> void:
	pass

func blockAction() -> void:	
	pass
