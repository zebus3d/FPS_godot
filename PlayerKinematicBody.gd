extends KinematicBody


var camera_angle = 0
var mouse_sensitivity = 0.3
var velocity = Vector3()
var direction = Vector3()

# walk setting
var gravity = -9.8 * 3
const MAX_SPEED = 20 
const MAX_RUNNING_SPEED = 30
const ACCEL = 2
const DEACCEL = 6

# jump settings
var jump_height = 15


# fly settings
const FLY_SPEED = 40
const FLY_ACCEL = 4

func _ready():
	pass

# warning-ignore:unused_argument
func _physics_process(delta):
	walk(delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		$CapsuleCollisionShape/Head.rotate_z(deg2rad(event.relative.x * mouse_sensitivity))
		
		var change = -event.relative.y * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$CapsuleCollisionShape/Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
			
func walk(delta):
	# reset player direction
	direction = Vector3()
	
	# get the rotation of the caemra
	var aim = $CapsuleCollisionShape/Head/Camera.get_global_transform().basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x

	
	direction = direction.normalized()
	
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var speed
	if Input.is_action_pressed("move_sprint"):
		speed = MAX_RUNNING_SPEED
	else:
		speed = MAX_SPEED
	
	# where the player go at max speed
	var target = direction * speed
	
	var acceleration 
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	# calculate a portion of the distance to go
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	# move
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if Input.is_action_pressed("jump"):
		velocity.y = jump_height

func fly(delta):
	# reset player direction
	direction = Vector3()
	
	# get the rotation of the caemra
	var aim = $CapsuleCollisionShape/Head/Camera.get_global_transform().basis
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x

	
	direction = direction.normalized()
	
	# where the player go at max speed
	var target = direction * FLY_SPEED
	
	# calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	# move
	move_and_slide(velocity)
