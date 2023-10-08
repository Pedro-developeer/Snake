extends Node2D

# Define a quantidade de segundos que o jogador tem para comer cada maçã.
@onready var time_period = 0.25

# Define o tempo atual em segundos.
var time = 0.0

# Define a quantidade de segundos que o jogo aguarda para gerar uma nova maçã.
@onready var apple_period = 3

# Define o tempo atual desde a última geração de maçã.
var apple_timer = 0.0

# Precarrega a cena da maçã.
@onready var apple_scene = preload("res://tscn/apple.tscn")

# Inicializa o jogo.
func _ready():
	# Define a pontuação inicial do jogador.
	Singletone.score = 0

# Lista de posições possíveis para a maçã.
var apple_positions = [
	475,425,375,325,275,225,175,125,75,25
]

# Processa o jogo.
func _process(delta):
	# Atualiza o tempo atual.
	time += delta

	# Atualiza o tempo desde a última geração de maçã.
	apple_timer += delta

	# Se o tempo atual for maior ou igual ao intervalo de tempo entre as maçãs,
	# então gera uma nova maçã.
	if time >= time_period:
		# Reinicia o tempo atual.
		time = 0.0

		# Chama o método `_tick()` de todos os nós no grupo "head".
		get_tree().call_group("head","_tick")

		# Chama o método `_tick()` de todos os nós no grupo "tail".
		get_tree().call_group("tail","_tick")

	# Se não houver nenhuma maçã na cena, então gera uma nova maçã.
	if get_tree().get_first_node_in_group("apple") != null:
		return

	# Se o tempo desde a última geração de maçã for maior ou igual ao intervalo
	# de tempo entre as maçãs, então gera uma nova maçã.
	if apple_timer >= apple_period:
		# Instancia uma nova maçã a partir da cena precarregada.
		var apple = apple_scene.instantiate()

		# Adiciona a maçã como um filho do nó atual.
		add_child(apple)

		# Define a posição da maçã aleatoriamente a partir da lista de posições possíveis.
		apple.position = Vector2(apple_positions.pick_random(),apple_positions.pick_random())

		# Reinicia o tempo desde a última geração de maçã.
		apple_timer = 0.0
