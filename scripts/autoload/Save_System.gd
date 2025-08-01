extends Node

const SETTINGS_PATH = "user://settings.cfg"

static func save_settings():
	var settings = {
		"resolution": Settings.current_resolution,
		"vsync": Settings.vsync_enabled,
		"audio": Settings.audio_settings
	}
	
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_var(settings)

static func load_settings():
	if FileAccess.file_exists(SETTINGS_PATH):
		var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		if file:
			return file.get_var()
	return null
