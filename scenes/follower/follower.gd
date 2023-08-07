extends CharacterBody2D

var anim: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = $AnimationPlayer


func _physics_process(delta):
	anim.play("player_idle")
