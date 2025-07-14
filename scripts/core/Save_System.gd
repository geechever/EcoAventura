extends Node

const SAVE_PATH = "user://game_save.dat"
const SETTINGS_PATH = "user://settings.cfg"

static func save_game():
	var data = {
		"progress": Global.game_data,
		"timestamp": Time.get_datetime_string_from_system()
	}
	save_to_path(data, SAVE_PATH)

static func save_settings():
	var settings = {
		"resolution": Settings.current_resolution,
		"audio": Settings.audio_settings,
		"game": Settings.game_settings
	}
	save_to_path(settings, SETTINGS_PATH)

static func load_settings():
	return load_from_path(SETTINGS_PATH)

static func save_to_path(data, path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(data)

static func load_from_path(path):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		return file.get_var()
	return null
