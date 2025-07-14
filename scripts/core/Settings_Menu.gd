extends CanvasLayer

@onready var resolution_option = $Panel/TabContainer/Pantalla/Resolution
@onready var fullscreen_check = $Panel/TabContainer/Pantalla/Fullscreen
@onready var master_slider = $Panel/TabContainer/Audio/MasterVolume
@onready var music_slider = $Panel/TabContainer/Audio/MusicVolume
@onready var sfx_slider = $Panel/TabContainer/Audio/SFXVolume
@onready var mute_check = $Panel/TabContainer/Audio/Mute
@onready var language_option = $Panel/TabContainer/Juego/Language
@onready var subtitles_check = $Panel/TabContainer/Juego/Subtitles

func _ready():
	load_settings()
	setup_options()
	animate_enter()

func animate_enter():
	$Panel.scale = Vector2(0.8, 0.8)
	$Panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property($Panel, "scale", Vector2(1,1), 0.3).set_trans(Tween.TRANS_BACK)
	tween.parallel().tween_property($Panel, "modulate:a", 1, 0.3)

func load_settings():
	var saved_settings = SaveSystem.load_settings()
	if saved_settings:
		Settings.current_resolution = saved_settings.get("resolution", 0)
		Settings.audio_settings = saved_settings.get("audio", Settings.audio_settings)
		Settings.game_settings = saved_settings.get("game", Settings.game_settings)
	
	resolution_option.selected = Settings.current_resolution
	master_slider.value = Settings.audio_settings["master_volume"]
	music_slider.value = Settings.audio_settings["music_volume"]
	sfx_slider.value = Settings.audio_settings["sfx_volume"]
	mute_check.button_pressed = Settings.audio_settings["muted"]
	subtitles_check.button_pressed = Settings.game_settings["subtitles"]

func setup_options():
	resolution_option.clear()
	for i in range(Settings.resolution_options.size()):
		resolution_option.add_item(Settings.resolution_options[i]["name"])
	
	language_option.clear()
	language_option.add_item("Español", 0)
	language_option.add_item("English", 1)
	language_option.selected = 0 if Settings.game_settings["language"] == "es" else 1

func _on_apply_pressed():
	save_current_settings()
	Settings.apply_current_settings()
	SaveSystem.save_settings()
	animate_exit()

func _on_back_pressed():
	save_current_settings()
	animate_exit()

func save_current_settings():
	Settings.current_resolution = resolution_option.selected
	Settings.audio_settings = {
		"master_volume": master_slider.value,
		"music_volume": music_slider.value,
		"sfx_volume": sfx_slider.value,
		"muted": mute_check.button_pressed
	}
	Settings.game_settings = {
		"language": "es" if language_option.selected == 0 else "en",
		"subtitles": subtitles_check.button_pressed
	}

func animate_exit():
	var tween = create_tween()
	tween.tween_property($Panel, "scale", Vector2(0.8,0.8), 0.2)
	tween.parallel().tween_property($Panel, "modulate:a", 0, 0.2)
	tween.tween_callback(queue_free)
