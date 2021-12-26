extends Control

var loader=null

func _ready():
	$Label.set_text("")
	set_process(false)
	
func load_scene(path):
	loader = ResourceLoader.load_interactive(path)
	if loader == null: print("ERROR EN LA CARGA: "+path)
	else: set_process(true)

func _process(delta):
	var LD = loader.poll()
	if LD == ERR_FILE_EOF: # Finished loading.
		var resource = loader.get_resource()
		loader = null
		get_tree().change_scene(resource.resource_path)
	elif LD == OK: # MIENTRAS HAYA MAS COSAS QUE CARGAR
		var progress = float(loader.get_stage()) / loader.get_stage_count()
		progress = floor(progress*100)
		$Label.set_text( "Descendiendo\n"+str(progress)+"%" )
