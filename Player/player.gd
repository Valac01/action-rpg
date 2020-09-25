extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK
}

const ACCELERATION = 480
const MAX_SPEED = 120
const ROLL_SPEED = 130
const FRICTION = 600
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT
var state = MOVE

onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

func _ready():
	animation_tree.active = true

func _physics_process(delta):
	
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		animation_state.travel("Run")
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
func move():
	velocity = move_and_slide(velocity)

func attack_state(_delta):
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func attack_state_finish():
	state = MOVE

func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
	move()
	animation_state.travel("Roll")
	
func roll_state_finish():
	velocity = velocity / 3
	state = MOVE