extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -350.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var anim: AnimationPlayer
var followers: Array[CharacterBody2D]


func _ready():
	anim = $AnimationPlayer
	followers = []


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("player_jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		$Sprite2D.flip_h = true
	elif direction == 1:
		$Sprite2D.flip_h = false

	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("player_run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("player_idle")
	if velocity.y > 0:
		anim.play("player_fall")
	
	move_and_slide()


func add_new_follower(follower):
	print("collecting")
	print(follower)
	
	if followers.size() == 0:
		follower.movement_target = self
	else:
		follower.movement_target = followers.back()
	follower.is_collectable = false
	followers.append(follower)


func _on_follower_collected(this_follower):
	add_new_follower(this_follower)


func _on_follower_2_collected(this_follower):
	add_new_follower(this_follower)


func _on_follower_3_collected(this_follower):
	add_new_follower(this_follower)


func _on_follower_4_collected(this_follower):
	add_new_follower(this_follower)


func _on_follower_5_collected(this_follower):
	add_new_follower(this_follower)
