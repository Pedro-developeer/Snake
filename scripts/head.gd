extends Node2D
class_name head

# Pré-carrega a cena da cauda da cobra.
@onready var tail_scene = preload("res://tscn/tail.tscn")

# Lista de caudas da cobra.
@onready var tails = []

# Define a última direção da cobra.
var last_vector = Vector2.RIGHT

# Define a direção atual da cobra.
var vector = Vector2.ZERO

# Define a posição anterior da cobra.
var previous_position = Vector2(275, 275)

func _process(delta):
	# Obtém o vetor de direção da cobra com base nas entradas do jogador.
	var _vector = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_up", "ui_down"))
	
	# Atualiza a direção atual da cobra se o vetor de direção não for zero.
	if _vector != Vector2.ZERO:
		vector = _vector

func _tick():
	# Verifica se há mais de uma cauda na cobra antes de atualizar a posição.
	if tails.size() > 1:
		# Verifica se a nova posição da cabeça colide com a posição anterior da cauda.
		# Se colidir, mantém a direção atual; caso contrário, atualiza a direção.
		if position_snap(position + vector * 50) == previous_position:
			vector = last_vector
		else:
			last_vector = vector
	
	# Atualiza a posição anterior para a posição atual da cabeça.
	previous_position = position
	
	# Move a cobra com base na direção atual.
	if vector.x != 0:
		position.x += vector.x * 50
	elif vector.y != 0:
		position.y += vector.y * 50
	
	# Ajusta a posição para garantir que a cobra permaneça dentro dos limites da tela.
	position = position_snap(position)
	
	# Verifica se a cobra colidiu com uma maçã, remove a maçã e atualiza a pontuação.
	for apple in Singletone.apples:
		if apple != null:
			if position == apple.position:
				Singletone.apples.erase(Singletone.apples.find(apple))
				apple.queue_free()
				_apple()
				Singletone.score += 50
				Singletone.apple_sound.play()
				break

func _apple():
	# Instancia uma nova cauda.
	var _tail = tail_scene.instantiate()
	
	# Define a próxima cauda com base no número de caudas existentes.
	if tails.size() <= 0:
		_tail.next_tail = self
	else:
		_tail.next_tail = tails[tails.size() - 1]
	
	# Adiciona a nova cauda à lista de caudas da cobra e a torna um filho do pai da cabeça.
	tails.push_back(_tail)
	get_parent().add_child.call_deferred(_tail)
	
	# Define a cor da nova cauda com base no tamanho atual da cobra.
	_tail.color(Color(0.5 - (tails.size() * 0.1), 0.5 - (tails.size() * 0.1), 0.5 - (tails.size() * 0.1)))

func position_snap(_position : Vector2):
	var pos = _position
	
	# Ajusta a posição se ela estiver fora dos limites da tela.
	if pos.x > 500:
		pos.x = 25
	elif pos.y > 500:
		pos.y = 25
	elif pos.x < 0:
		pos.x = 475
	elif pos.y < 0:
		pos.y = 475
	
	return pos
