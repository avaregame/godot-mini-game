extends CanvasLayer

# Mevcut değişkenler aynı...
@onready var character_name: Label = $Background/MarginContainer/VBoxContainer/Title/CharacterName
@onready var avatar: TextureRect = $Background/MarginContainer/VBoxContainer/Title/Avatar
@onready var dialog_text: RichTextLabel = $Background/MarginContainer/VBoxContainer/DialogText
@onready var options_container: VBoxContainer = $Background/MarginContainer/VBoxContainer/Options

var dialog_data: Dictionary
var current_dialog_id: String

func _ready():
	hide_dialog()
	load_dialog_data()
	
	# CRITICAL: Bu node paused durumda da çalışsın
	process_mode = Node.PROCESS_MODE_ALWAYS

func load_dialog_data():
	var file = FileAccess.open("res://assets/dialogs/dialog_data.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		dialog_data = JSON.parse_string(json_text)
		file.close()
	else:
		push_error("Dosya bulunamadı: res://assets/dialogs/dialog_data.json")

func show_dialog(dialog_id: String):
	current_dialog_id = dialog_id
	var dialog = dialog_data.get(dialog_id)
	
	if dialog:
		character_name.text = dialog.get("character", "")
		dialog_text.text = dialog["text"]
		
		# Avatar texture'ını yükle
		var avatar_path = dialog.get("avatar", "")
		if avatar_path and ResourceLoader.exists(avatar_path):
			avatar.texture = load(avatar_path)
		else:
			avatar.texture = null
		
		clear_options()
		
		# Seçenekleri oluştur - DAHA BÜYÜK butonlar
		for option in dialog.get("options", []):
			var button = Button.new()
			button.text = option["text"]
			button.custom_minimum_size = Vector2(300, 40)  # Büyük butonlar
			button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			button.connect("pressed", _on_option_selected.bind(option["next"]))
			options_container.add_child(button)
		
		show()
		
		# Oyunu duraklat ama UI çalışsın
		get_tree().paused = true
	else:
		push_error("Dialog bulunamadı: " + dialog_id)

func clear_options():
	for child in options_container.get_children():
		child.queue_free()

func _on_option_selected(next_dialog_id: String):
	if next_dialog_id == "close":
		hide_dialog()
	else:
		show_dialog(next_dialog_id)

func hide_dialog():
	hide()
	# Player kontrolünü geri ver
	get_tree().paused = false

func _input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		hide_dialog()
