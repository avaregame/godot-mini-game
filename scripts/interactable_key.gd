extends Area2D

@export var item_name: String = "Gizemli Anahtar"
@export var interaction_text: String = "E tuşuna basarak al"

var player_in_range: bool = false

func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		print("Anahtar yakınında! ", interaction_text)

func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		print("Anahtardan uzaklaştı")

func _input(event):
	if player_in_range and event.is_action_pressed("ui_interact"):
		collect_item()

func collect_item():
	print(item_name, " toplandı!")
	# Burada toplama animasyonu, envantere ekleme vs. yapılabilir
	queue_free()  # Nesneyi sahneden kaldır
