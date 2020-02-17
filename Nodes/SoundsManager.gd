extends Node2D

var musicASP
var soundASP
var musics={}
var musics_seek={}
var old_song
var sounds={}
var sounds_variedad={}

func _ready():
	randomize()
	musicASP=AudioStreamPlayer.new()
	add_child(musicASP)
	soundASP=AudioStreamPlayer.new()
	add_child(soundASP)
	add_all_sounds()	
	play_music("music_dungeon1")

func add_all_sounds():
	add_music("music_dungeon1")
	add_music("music_combat")
	add_sound("Chest",2)
	add_sound("Golpe",4)
	add_sound("Miss",4)
	add_sound("Lockpick_fail")
	add_sound("Lockpick_start")
	add_sound("Lockpick_win")
	add_sound("UI_accept")
	add_sound("UI_move")
	add_sound("UI_tile_accept")
	add_sound("UI_tile_move")

func add_music(song):
	musics[song]=load("res://Sounds/"+song+".ogg")

func add_sound(sfx,variedad=0):
	if variedad==0: sounds[sfx]=load("res://Sounds/SFX/"+sfx+".wav")
	else:
		for i in range(1,variedad+1):
			sounds[sfx+"_"+str(i)]=load("res://Sounds/SFX/"+sfx+"_"+str(i)+".wav")
	sounds_variedad[sfx]=variedad

func play_music(song,continue_in_seek=false):
	musics_seek[old_song]=musicASP.get_playback_position()
	musicASP.stream=musics[song]
	musicASP.play()
	if continue_in_seek: musicASP.seek(musics_seek[song])
	old_song=song

func play_sfx(sfx):
	var real_sfx=sfx
	if sounds_variedad[sfx]>0: real_sfx=sfx+"_"+str(randi()%sounds_variedad[sfx]+1)
	soundASP.stream=sounds[real_sfx]
	soundASP.play()
	#print(real_sfx)