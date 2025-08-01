extends CanvasLayer

var settings_menu_instance = null

func _ready():
	# Cargar configuración al iniciar
		var settings = SaveSystem.load_settings()


func _on_settings_button_pressed():
	if settings_menu_instance == null:
		settings_menu_instance = preload("res://scenes/core/ui/Settings_Menu.tscn").instantiate()
		add_child(settings_menu_instance)
	else:
		settings_menu_instance.show()
