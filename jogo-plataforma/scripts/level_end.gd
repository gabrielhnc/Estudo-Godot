extends Area2D

@export var next_level = "" 

# Configurações de Collision Mask para indicar qual irá colidir com o LevelEnd
func _on_body_entered(_body: Node2D) -> void:
	call_deferred("load_next_scene")
	
# Em cada LEVEL END definido nas fases, a váriavel next_level recebe a proxima e troca a cena que o player esta inserido
func load_next_scene():
	get_tree().change_scene_to_file("res://cenas/" + next_level + ".tscn")
