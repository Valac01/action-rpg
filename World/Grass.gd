extends Node2D

# func _process(_delta):
# 	# Attaching GrassEffect node inside the grass node
# 	# Referencing the GrassEffect node
# 	var GrassEffect = load("res://Effects/GrassEffect.tscn")
# 	if Input.is_action_just_pressed("attack"):
# 		# Instancing the GrassEffect node
# 		var grassEffect = GrassEffect.instance()
		
# 		# Instancing the Current World node
# 		var world = get_tree().current_scene
# 		world.add_child(grassEffect)

# 		# Setting the same position as the grass
# 		grassEffect.global_position = global_position
# 		queue_free()

onready var animatedSprite = $AnimatedSprite

func _ready():
	animatedSprite.hide()

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		$Sprite.queue_free()
		animatedSprite.show()
		animatedSprite.play("grassEffectAnimation")


func _on_AnimatedSprite_animation_finished():
	queue_free()