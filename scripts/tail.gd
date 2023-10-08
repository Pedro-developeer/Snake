extends Node2D

# Variáveis de controle de posição e referência à próxima cauda
@onready var previous_position = Vector2.ZERO
@onready var next_tail : Node2D
@onready var head_position = Vector2.ZERO

# Referência à cabeça da serpente
@onready var head 

# Referência ao sprite da cauda
@onready var sprite : Sprite2D

func _ready():
	# Obtém a referência à cabeça da serpente
	head = get_tree().get_nodes_in_group("head")[0]

func _tick():
	# Atualiza a posição anterior e atual da cauda
	previous_position = position
	position = next_tail.previous_position
	
	# Obtém a posição atual da cabeça da serpente
	head_position = head.position
	
	# Verifica se a cauda colidiu com a cabeça, reinicia o jogo em caso positivo
	if position == head_position:
		get_tree().reload_current_scene()
	
	# Verifica se a cauda colidiu com uma maçã
	if Singletone.apples.size() < 0:
		return
	
	for apple in Singletone.apples:
		if apple != null:
			if position == apple.position:
				Singletone.apples.erase(Singletone.apples.find(apple))
				apple.queue_free()
				head._apple()
				Singletone.score += 50
				Singletone.apple_sound.play()
				break

func color(X):
	# Define a cor do sprite da cauda
	sprite = $Sprite2D
	sprite.modulate = X
