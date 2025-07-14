extends Node

# Resolución
var resolution_options = [
	{"name": "1280x720", "width": 1280, "height": 720},
	{"name": "1920x1080", "width": 1920, "height": 1080},
	{"name": "Pantalla Completa", "fullscreen": true}
]
var current_resolution = 0

# Audio
var audio_settings = {
	"master_volume": 80,
	"music_volume": 80,
	"sfx_volume": 80,
	"muted": false
}

# Juego
var game_settings = {
	"language": "es",
	"subtitles": true,
	"tutorial": true
}

func apply_current_settings():
	apply_resolution()
	apply_audio()

func apply_resolution():
	var res = resolution_options[current_resolution]
	if res.has("fullscreen"):
		get_window().mode = Window.MODE_FULLSCREEN
	else:
		get_window().mode = Window.MODE_WINDOWED
		get_window().size = Vector2(res["width"], res["height"])

func apply_audio():
	AudioServer.set_bus_mute(0, audio_settings["muted"])
	AudioServer.set_bus_volume_db(0, linear_to_db(audio_settings["master_volume"]/100.0))
	AudioServer.set_bus_volume_db(1, linear_to_db(audio_settings["music_volume"]/100.0))
	AudioServer.set_bus_volume_db(2, linear_to_db(audio_settings["sfx_volume"]/100.0))
