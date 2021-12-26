class_name Movible

var own
var isMoving=false
var steps=0
var tween_move

func _init(_owner):
	own=_owner
	tween_move=Tween.new()
	own.add_child(tween_move)

func set_tile_des(tile_des):
	move_tween(tile_des)
	#FLIPEAMOS EL SPRITE
	var own_pos=own.TILEABLE.get_tile_pos()
	if tile_des.x!=own_pos.x: own.get_node( "Sprite" ).set_flip_h( tile_des.x<own_pos.x )
	own.set_z_index(11+tile_des.y)

func move_tween(tile_des):
	isMoving=true
	var world_des=Globals.tile_map.map_to_world(tile_des)+Globals.tile_map.cell_size/2
	tween_move.interpolate_property(own, "position",own.position, world_des, 0.3,Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween_move.start()
	yield(tween_move, "tween_completed")
	own.TILEABLE.set_tile_pos(tile_des)
	isMoving=false
