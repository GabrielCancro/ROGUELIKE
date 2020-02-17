extends Node2D
var loader

func goto_scene(path): #llamar para cargar una nueva escena
	loader = ResourceLoader.load_interactive(path)
	set_process(true)

func _process(delta):
	var LOAD = loader.poll()  #cargamos un elemento
	if LOAD == OK:
		var progress = float(loader.get_stage()) / loader.get_stage_count()
	elif LOAD == ERR_FILE_EOF: # Finished loading.
		set_new_scene( loader.get_resource() )

func set_new_scene(res): #elimina escena vieja e instancia la nueva
	var old_scn = get_node( "/root" ).get_node( "/root/Node2D" )
	get_node( "/root" ).remove_child( old_scn )
	get_node( "/root" ).add_child( res.instance() )

