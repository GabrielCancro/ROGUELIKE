extends Node2D

var loader=null
var loader_label=""
func _ready():
	set_process(false)
	
func goto_scene(path,loaderLabel): # game requests to switch to this scene
	loader_label=loaderLabel
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		print("ERROR EN LA CARGA: "+path)
		return
	else:
		set_process(true)
		$pointer.set_process(false)

func _process(delta):
	var LD = loader.poll()
	if LD == ERR_FILE_EOF: # Finished loading.
		var resource = loader.get_resource()
		loader = null		
		set_new_scene(resource)
	elif LD == OK: # MIENTRAS HAYA MAS COSAS QUE CARGAR
		var progress = float(loader.get_stage()) / loader.get_stage_count()
		progress = floor(progress*100)
		loader_label.set_text( "Falling..  "+str(progress)+"%" )

func set_new_scene(res):
	get_tree().change_scene(res.resource_path)
#	var root=get_node("/root")
#	var scn1 = root.get_node("Node2D")
#	root.remove_child(scn1)
#	scn1.call_deferred("free")
#	var scn2 = res.instance()
#	root.add_child(scn2)
#	if(res.resource_path=="res://Game/main.tscn"): 
#		Globals._initGlobals()