extends Node

# Lista de maçãs no jogo.
@onready var apples = []

# Reprodutor de áudio para efeitos sonoros de maçãs.
@onready var apple_sound : AudioStreamPlayer

# Pontuação atual do jogador.
var score = 0
