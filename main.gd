extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# Para que en html5 capture el raton solo al hacer click: 
# en Proyecto Ajustes de Proyecto > Mapa de Entrada habilite left_click.
# se puede usar _input(event) o _unhandled_input(event)
func _unhandled_input(event):
	if Input.is_action_pressed("left_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()

func _physics_process(delta):
	print("FPS: ", Performance.get_monitor(Performance.TIME_FPS))
