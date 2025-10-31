extends CharacterBody2D

# Bu değişkenler karakterimizin hızını kontrol edecek.
@export var speed: int = 100
@export var acceleration: int = 10

func _ready():
	# Oyun başladığında bir kerelik çalışan fonksiyon.
	pass

func _physics_process(delta):
	# Fizik hesaplamaları için her karede çalışan fonksiyon.
	
	# 1. Kullanıcı inputunu al.
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_direction = input_direction.normalized()
	
	# 2. Hızı hesapla ve uygula.
	velocity = velocity.move_toward(input_direction * speed, acceleration)
	
	# 3. Hareketi gerçekleştir ve çarpışmaları kontrol et.
	move_and_slide()
