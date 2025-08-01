extends CanvasLayer

# --- RUTAS @onready ACTUALIZADAS PARA TU ESTRUCTURA ACTUAL ---
# 'center_panel' es el CenterContainer, y 'Panel' es el nodo principal de tu UI dentro de él.
@onready var main_container_panel = $center_panel/Panel # Aquí es donde estaba $Panel, ahora es $center_panel/Panel

@onready var resolution_option = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Display/GridContainer/ResolutionOption
@onready var vsync_check = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Display/GridContainer/VSyncCheck
@onready var fullscreen_check = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Display/GridContainer/FullscreenCheck

@onready var master_slider = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Audio/GridContainer/MasterSlider
@onready var master_value = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Audio/GridContainer/MasterValue
@onready var music_slider = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Audio/GridContainer/MusicSlider
@onready var music_value = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Audio/GridContainer/MusicValue
@onready var sfx_slider = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Audio/GridContainer/SFXSlider
@onready var sfx_value = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Audio/GridContainer/SFXValue
@onready var mute_check = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Audio/GridContainer/MuteCheck

@onready var apply_button = $center_panel/Panel/MarginContainer/VBoxContainer/HBoxContainer/ApplyButton
@onready var back_button = $center_panel/Panel/MarginContainer/VBoxContainer/HBoxContainer/BackButton

func _ready():
	# Eliminamos la llamada a center_panel(), ya que el CenterContainer lo maneja.
	load_ui_settings()
	connect_signals()
	setup_containers() # Esta función ajustará los size_flags de los controles.

# --- FUNCIÓN center_panel() ELIMINADA ---
# Elimina toda esta función, ya no es necesaria.
# func center_panel():
#     pass

func setup_containers():
	# Configurar contenedores principales para que llenen el espacio disponible
	# La ruta debe ser relativa al nodo que contiene el script, en este caso CanvasLayer
	$center_panel/Panel/MarginContainer/VBoxContainer.size_flags_horizontal = Control.SIZE_FILL
	$center_panel/Panel/MarginContainer/VBoxContainer.size_flags_vertical = Control.SIZE_FILL
	
	# Configurar GridContainers para que llenen el espacio horizontal
	var display_grid = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Display/GridContainer
	var audio_grid = $center_panel/Panel/MarginContainer/VBoxContainer/TabContainer/Audio/GridContainer
	
	display_grid.size_flags_horizontal = Control.SIZE_FILL
	audio_grid.size_flags_horizontal = Control.SIZE_FILL
	
	# --- AJUSTE CLAVE: Size Flags de los hijos de GridContainer ---
	# Esto asegura que los elementos dentro de la rejilla se distribuyan correctamente.
	
	# Controles de Display
	# Etiquetas (Label): Generalmente se encogen y se centran
	display_grid.get_node("Resolución").size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	display_grid.get_node("Pantalla Completa").size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	display_grid.get_node("Vsync2").size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	# OptionButton y CheckBox: También suelen encogerse y centrarse
	resolution_option.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	fullscreen_check.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vsync_check.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	# Controles de Audio
	# Etiquetas:
	audio_grid.get_node("Volumen General").size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	# Confirma el nombre exacto de tu nodo Label para "Música" y "Efectos de Sonido"
	audio_grid.get_node("Musica").size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	audio_grid.get_node("Efectos de Sonido").size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	audio_grid.get_node("Silenciar").size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	# Sliders (Controles deslizantes): Querrás que se expandan para rellenar su celda
	master_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	music_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sfx_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	# Etiquetas de valor (ej: 50%): Suelen encogerse y centrarse
	master_value.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	music_value.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	sfx_value.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	# CheckBox de mutear:
	mute_check.size_flags_horizontal = Control.SIZE_SHRINK_CENTER


func connect_signals():
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	mute_check.toggled.connect(_on_mute_toggled)
	apply_button.pressed.connect(_on_apply_pressed)
	back_button.pressed.connect(_on_on_back_pressed) # Corregido nombre de la señal

func load_ui_settings():
	resolution_option.clear()
	for option in Settings.resolution_options:
		resolution_option.add_item(option["name"])
	
	resolution_option.selected = Settings.current_resolution
	vsync_check.button_pressed = Settings.vsync_enabled
	
	# Asegúrate de que Settings.resolution_options[Settings.current_resolution] sea válido antes de acceder
	if Settings.current_resolution >= 0 and Settings.current_resolution < Settings.resolution_options.size():
		fullscreen_check.button_pressed = Settings.resolution_options[Settings.current_resolution].has("fullscreen")
	else:
		# Manejar caso donde current_resolution no es válido, por ejemplo, establecer a false
		fullscreen_check.button_pressed = false
	
	master_slider.value = Settings.audio_settings["master_volume"]
	music_slider.value = Settings.audio_settings["music_volume"]
	sfx_slider.value = Settings.audio_settings["sfx_volume"]
	mute_check.button_pressed = Settings.audio_settings["muted"]
	
	update_volume_labels()

func update_volume_labels():
	master_value.text = str(master_slider.value) + "%"
	music_value.text = str(music_slider.value) + "%"
	sfx_value.text = str(sfx_slider.value) + "%"

func _on_master_volume_changed(value):
	master_value.text = str(value) + "%"
	Settings.audio_settings["master_volume"] = value

func _on_music_volume_changed(value):
	music_value.text = str(value) + "%"
	Settings.audio_settings["music_volume"] = value

func _on_sfx_volume_changed(value):
	sfx_value.text = str(value) + "%"
	Settings.audio_settings["sfx_volume"] = value

func _on_mute_toggled(toggled):
	Settings.audio_settings["muted"] = toggled

func _on_apply_pressed():
	save_current_settings()
	Settings.apply_current_settings()
	# Assuming SaveSystem is an autoload and its functions are not 'static'
	SaveSystem.save_settings()
	
	# Feedback visual
	apply_button.text = "¡Aplicado!"
	await get_tree().create_timer(1.0).timeout
	apply_button.text = "Aplicar"

func _on_on_back_pressed(): # Nombre de la función corregido para coincidir con la señal
	# Assuming SaveSystem is an autoload and its functions are not 'static'
	var settings_data = SaveSystem.load_settings()
	if settings_data:
		Settings.load_settings_data(settings_data)
	hide()
	queue_free()

func save_current_settings():
	Settings.current_resolution = resolution_option.selected
	Settings.vsync_enabled = vsync_check.button_pressed
	
	# Modificado para manejar mejor el caso de la resolución fullscreen.
	# Si se activa el fullscreen, busca la primera resolución que lo tenga.
	# Si se desactiva, y la resolución actual es fullscreen, vuelve a la primera no-fullscreen.
	if fullscreen_check.button_pressed:
		var found_fullscreen_res = false
		for i in range(Settings.resolution_options.size()):
			if Settings.resolution_options[i].has("fullscreen"):
				Settings.current_resolution = i
				found_fullscreen_res = true
				break
		if not found_fullscreen_res:
			# Si no hay resoluciones fullscreen, mantener la seleccionada o la primera
			push_warning("No se encontró ninguna resolución con la opción 'fullscreen'.")
	else:
		# Si se desactiva fullscreen, y la resolución actual lo tiene, cambia a una no-fullscreen.
		if Settings.current_resolution >= 0 and Settings.current_resolution < Settings.resolution_options.size() and \
		   Settings.resolution_options[Settings.current_resolution].has("fullscreen"):
			# Buscar la primera resolución no-fullscreen para cambiar
			var changed_res = false
			for i in range(Settings.resolution_options.size()):
				if not Settings.resolution_options[i].has("fullscreen"):
					Settings.current_resolution = i
					changed_res = true
					break
			if not changed_res:
				push_warning("No se encontró ninguna resolución sin la opción 'fullscreen'.")

# --- _notification ELIMINADO ---
# Ya no es necesario manejar el cambio de tamaño del viewport manualmente aquí.
# func _notification(what):
#	if what == NOTIFICATION_WM_SIZE_CHANGED:
#		pass
