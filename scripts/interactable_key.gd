extends Area2D

@export var dialog_id: String = "test_dialog"
@export var npc_name: String = "Gizemli Yabancı"

func _ready():
	# Collision ayarları
	collision_layer = 2  # Interactable layer
	collision_mask = 1   # Player layer'ı ile etkileşim
	
	# GRUBA EKLE - BU ÇOK ÖNEMLİ!
	add_to_group("interactables")
	
	# InteractionHint'i gizle
	if has_node("InteractionHint"):
		$InteractionHint.hide()

# SINYALLERİ OTOMATİK BAĞLAMA - Godot zaten bağlıyor!
# Ayrıca connect() yapmıyoruz!

func _on_body_entered(body):
	print("🚶 Body entered interactable_key: ", body.name)
	if body.name == "Player" and has_node("InteractionHint"):
		$InteractionHint.show()

func _on_body_exited(body):
	print("🏃 Body exited interactable_key: ", body.name)  
	if body.name == "Player" and has_node("InteractionHint"):
		$InteractionHint.hide()

func get_dialog_id():
	return dialog_id
