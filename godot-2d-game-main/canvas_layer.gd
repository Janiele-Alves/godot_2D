extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var lives_label = $LivesLabel
@onready var time_label = $TimeLabel

func update_score(value: int):
	score_label.text = "Pontuação: " + str(value)

func update_lives(value: int):
	lives_label.text = "Vidas: " + str(value)

func update_time(value: int):
	time_label.text = "Tempo: " + str(value)
