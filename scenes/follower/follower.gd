extends CharacterBody2D

@export var movement_target: CharacterBody2D
@export var navigation_agent: NavigationAgent2D

var anim: AnimationPlayer
var is_collectable: bool
var jump_detect_cast: RayCast2D
const SPEED: float = 150.0
const JUMP_VELOCITY: float = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal collected(this_follower: CharacterBody2D)

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $AnimationPlayer
	is_collectable = true
	jump_detect_cast = $Flippables/Sprite2D/RayCast2D
	
	navigation_agent.path_desired_distance = 32.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame

func _physics_process(delta):
	if movement_target != null:
		navigation_agent.target_position = movement_target.position

		if navigation_agent.is_navigation_finished() == false:
			var next_path_position: Vector2 = navigation_agent.get_next_path_position()
			var direction = (next_path_position - global_position).normalized()
			
			var direction_angle = rad_to_deg(direction.angle())
			
			if direction.x < 0:
				velocity.x = -1 * SPEED
				$Flippables.scale.x = -1
				anim.play("follower_run")
			elif direction.x > 0:
				velocity.x = SPEED
				$Flippables.scale.x = 1
				anim.play("follower_run")
			if is_on_floor():
				if jump_detect_cast.is_colliding() == false and direction.y <= 0:
					velocity.y = JUMP_VELOCITY
				if direction_angle < -60 and direction_angle > -120:
					velocity.y = JUMP_VELOCITY
		else:
			velocity.x = 0
			

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.x == 0:
			anim.play("follower_idle")
	
	if velocity.y > 0:
		anim.play("follower_fall")
	elif velocity.y < 0:
		anim.play("follower_jump")
		
	move_and_slide()


func _on_area_2d_body_entered(_body):
	if is_collectable:
		collected.emit(self)
