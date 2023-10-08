extends Control

# Referência à GUI de pontuação no nó da cena.
@onready var score = $score

# Atualiza a GUI de pontuação com a pontuação atual do jogador.
func _tick():
	score.text = "Score: " + str(Singletone.score)



