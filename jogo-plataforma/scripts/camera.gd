# SCRIPT da Camera atribuida as cenas onde o jogador está inserido
# As funções aqui presentes são válidas para todas as instancias, porém podem ser alteradas
# localmente em cada cena

extends Camera2D

var target: Node2D

# Called when the node enters the scene tree for the first time.
# Função responsável por "carregar" todos os nodes de uma cena
func _ready() -> void:
	get_target()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# Função que é executada a cada frame do jogo continuamente
func _process(_delta: float) -> void:
	position = target.position # Posição da camera recebe a posção do "alvo" (PLAYER)

# Busca o alvo (PLAYER) guardando na variavel "nodes" todos os nodes presentes no grupo Player
func get_target():
	var nodes = get_tree().get_nodes_in_group("Player")
	# Se nada for guardado na variavel, nodes.size() será igual a 0 disparando uma mensagem de erro
	if nodes.size() == 0:
		push_error("Player not found!")
		return
		
	# Atribui ao target o indice 0 do grupo Player o qual esta guardado na variavel nodes (Grupo é semelhante a uma lista)
	target = nodes[0]
