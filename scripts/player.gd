extends CharacterBody2D

@export var speed: int = 100
@export var acceleration: int = 10

func _ready():
	pass

func _physics_process(_delta):  # _delta şeklinde düzelt
	# 1. Kullanıcı inputunu al.
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_direction = input_direction.normalized()
	
	# 2. Hızı hesapla ve uygula.
	velocity = velocity.move_toward(input_direction * speed, acceleration)
	
	# 3. Hareketi gerçekleştir ve çarpışmaları kontrol et.
	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("ui_interact"):
		print("🎮 INTERACT TUŞU BASILDI!")
		
		# Önce basit yöntemi dene
		var interactable = get_closest_interactable_simple()
		if interactable:
			print("✅ Interactable bulundu: ", interactable.name)
			start_dialog(interactable.dialog_id)
		else:
			print("❌ Yakında interactable nesne YOK")
			# Fizik sorgusunu da dene
			interactable = get_closest_interactable()
			if interactable:
				print("✅ Fizik sorgusu ile bulundu: ", interactable.name)
				start_dialog(interactable.dialog_id)

func get_closest_interactable():
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = global_position
	query.collision_mask = 2  # Interactable layer
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var result = space_state.intersect_point(query)
	print("📡 Fizik sorgusu sonucu: ", result.size(), " nesne")
	
	for collision in result:
		print("   - Bulunan: ", collision.collider.name)
		if collision.collider.has_method("get_dialog_id"):
			print("   ✅ Dialog metodu var!")
			return collision.collider
		else:
			print("   ❌ Dialog metodu YOK")
	
	return null

func get_closest_interactable_simple():
	# Tüm interactable'ları gruptan al
	var interactables = get_tree().get_nodes_in_group("interactables")
	print("🔍 Gruptaki interactable sayısı: ", interactables.size())
	
	var closest = null
	var closest_distance = 100.0  # 100 piksel menzil
	
	for interactable in interactables:
		var distance = global_position.distance_to(interactable.global_position)
		print("   - ", interactable.name, " mesafe: ", distance)
		
		if distance < closest_distance:
			closest = interactable
			closest_distance = distance
	
	return closest

func start_dialog(dialog_id: String):
	var dialog_box = get_node_or_null("/root/World/DialogBox")
	if dialog_box:
		print("🎭 Dialog başlatılıyor: ", dialog_id)
		get_tree().paused = true  # Oyunu duraklat
		dialog_box.show_dialog(dialog_id)
	else:
		print("❌ DialogBox bulunamadı!")
