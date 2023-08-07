extends CharacterBody2D

@export var movement_target: CharacterBody2D
@export var navigation_agent: NavigationAgent2D

var anim: AnimationPlayer
var is_collectable: bool
const SPEED: float = 150.0
const JUMP_VELOCITY: float = -350.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $AnimationPlayer
	is_collectable = true
	
	navigation_agent.path_desired_distance = 32.0
	navigation_agent.target_desired_distance = 4.0
	
	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame

func _physics_process(delta):
	if movement_target != null:
		navigation_agent.target_position = movement_target.position

		if navigation_agent.is_navigation_finished() == false:
			var current_agent_position: Vector2 = global_position
			var next_path_position: Vector2 = navigation_agent.get_next_path_position()
			var distance = (next_path_position - global_position).normalized()
			
			print(distance)
			
			if distance.x < 0:
				velocity.x = -1 * SPEED
				$Sprite2D.flip_h = true
				anim.play("player_run")
			elif  distance.x > 0:
				velocity.x = SPEED
				$Sprite2D.flip_h = false
				anim.play("player_run")
		else:
			velocity.x = 0
			

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if velocity.x == 0:
			anim.play("player_idle")
	
	if velocity.y > 0:
		anim.play("player_fall")
	elif velocity.y < 0:
		anim.play("player_jump")
		
	move_and_slide()


func _on_area_2d_body_entered(body):
	if is_collectable:
		print("collected")
		movement_target = body
		is_collectable = false
