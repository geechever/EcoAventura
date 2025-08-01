extends CanvasLayer

@onready var resolution_option = $Panel/TabContainer/Display/ResolutionOption
@onready var vsync_check = $Panel/TabContainer/Display/VSyncCheck
@onready var master_slider = $Panel/TabContainer/Audio/MasterSlider
@onready var mute_check = $Panel/TabContainer/Audio/MuteCheck



func _ready():
	# Centrar el panel principal
	$Panel.anchor_left = 0.5
	$Panel.anchor_top = 0.5
	$Panel.anchor_right = 0.5
	$Panel.anchor_bottom = 0.5
	$Panel.pivot_offset = $Panel.size / 2
	var viewport_size = get_viewport().size
	$Panel.custom_minimum_size = Vector2(viewport_size.x * 0.8, viewport_size.y * 0.8)
	$Panel.position = viewport_size / 2 - $Panel.size / 2

func load_ui_settings():
	# Configurar UI con los valores actuales
	resolution_option.selected = Settings.current_resolution
	vsync_check.button_pressed = Settings.vsync_enabled
	master_slider.value = Settings.audio_settings["master_volume"]
	mute_check.button_pressed = Settings.audio_settings["muted"]
	
	# Configurar opciones de resolución
	resolution_option.clear()
	for option in Settings.resolution_options:
		resolution_option.add_item(option["name"])

func _on_apply_pressed():
	save_current_settings()
	Settings.apply_current_settings()
	SaveSystem.save_settings()

func save_current_settings():
	Settings.current_resolution = resolution_option.selected
	Settings.vsync_enabled = vsync_check.button_pressed
	Settings.audio_settings = {
		"master_volume": master_slider.value,
		"music_volume": Settings.audio_settings["music_volume"],
		"sfx_volume": Settings.audio_settings["sfx_volume"],
		"muted": mute_check.button_pressed
	}
