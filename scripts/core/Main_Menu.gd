extends CanvasLayer

var settings_menu_instance = null

func _ready():
	# Cargar configuración
	var settings = SaveSystem.load_settings()
	if settings:
		Settings.load_settings_data(settings)
	else:
		Settings.apply_current_settings()
	
	# Cargar datos del juego
	SaveSystem.load_game()

func _on_settings_button_pressed():
	if settings_menu_instance == null:
		# CORRECCIÓN: Usar la ruta correcta según tu estructura de archivos
		settings_menu_instance = preload("res://scenes/core/ui/Settings_Menu.tscn").instantiate()
		add_child(settings_menu_instance)
		# Conectar señal de cierre
		settings_menu_instance.tree_exited.connect(_on_settings_closed)
	else:
		settings_menu_instance.show()

func _on_settings_closed():
	settings_menu_instance = null

func _on_exit_button_pressed():
	get_tree().quit()

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/world/Level1.tscn")
