extends CharacterBody2D
# TODO: Add roll action



@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

const SPEED : float = 200.0



func _ready() -> void:
	sprite.animation_finished.connect(animationFinished)


func _physics_process(delta: float) -> void:
	var direction_x := Input.get_axis("analog_left", "analog_right")
	var direction_y := Input.get_axis("analog_up", "analog_down")
	var isRolling : bool = Input.is_action_pressed("shift")


	walkAction(direction_x, direction_y)
	turnDirectionAction(direction_x, direction_y)

	rollAction(isRolling)
	move_and_slide()


func isPlayerWalking (velocity: Vector2) -> bool:
	return false if velocity == Vector2(0,0) else true

func walkAction(dir_x : float,dir_y : float):
	if dir_x or dir_y:
		velocity = Vector2(dir_x,dir_y).normalized() * SPEED
		sprite.play("walking")

	if not dir_x:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if not dir_y:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if not isPlayerWalking(velocity):
		sprite.play("idle")


func turnDirectionAction(dir_x : float, dir_y : float):
	if dir_x > 0:
		sprite.flip_h = false
	elif dir_x < 0:
		sprite.flip_h = true


func rollAction(rolling : bool):
	if rolling and isPlayerWalking(velocity):
		sprite.play("rolling")
		print("start rolling")
		print(sprite.animation_finished.is_connected(animationFinished))


func animationFinished():
	print("finish rolling")



	
