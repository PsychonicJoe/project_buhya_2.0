extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 7.0
export var jump_strength = 20.0
export var gravity = 50.0
export var camera_height = 5

var _velocity = Vector3.ZERO
var _snapVector = Vector3.DOWN

onready var _springArm: SpringArm = $SpringArm
onready var _model: Spatial = $CSGMesh

func _physics_process(delta):
	var move_direction = Vector3.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, _springArm.rotation.y).normalized()
	_velocity.x = move_direction.x * speed
	_velocity.z = move_direction.z * speed
	_velocity.y -= gravity * delta
	var justLanded = is_on_floor() and _snapVector == Vector3.ZERO
	var isJumping = is_on_floor() and Input.is_action_just_pressed("jump")
	if isJumping:
		_velocity.y = jump_strength
		_snapVector = Vector3.ZERO
	elif justLanded:
		_snapVector = Vector3.DOWN
	_velocity = move_and_slide_with_snap(_velocity, _snapVector, Vector3.UP, true)
	
	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y = look_direction.angle()
	
func _process(delta):
	_springArm.translation = translation
	_springArm.translation.y += camera_height

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
