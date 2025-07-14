extends CanvasLayer

var settings_menu_instance = null

func _ready():
	get_window().min_size = Vector2(1280, 720)
	load_initial_settings()

func load_initial_settings():
	var settings = SaveSystem.load_settings()
	if settings:
		Settings.current_resolution = settings.get("resolution", 0)
		Settings.audio_settings = settings.get("audio", Settings.audio_settings)
		Settings.game_settings = settings.get("game", Settings.game_settings)
	Settings.apply_current_settings()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/worlds/level_1.tscn")

func _on_settings_button_pressed():
	if settings_menu_instance == null:
		settings_menu_instance = preload("res://scenes/core/settings_menu.tscn").instantiate()
		add_child(settings_menu_instance)
	else:
		settings_menu_instance.visible = true

func _on_exit_button_pressed():
	SaveSystem.save_game()
	get_tree().quit()
