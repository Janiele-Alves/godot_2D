extends Area2D

signal hit

@export var speed = 400
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("mover_direita"):
		velocity.x += 1
	if Input.is_action_pressed("mover_esquerda"):
		velocity.x -= 1
	if Input.is_action_pressed("mover_baixo"):
		velocity.y += 1
	if Input.is_action_pressed("mover_cima"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.animation = "stand_by"
		$AnimatedSprite2D.play()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		if velocity.y > 0:
			$AnimatedSprite2D.animation = "go_down"
		else:
			$AnimatedSprite2D.animation = "go_up"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
func _on_body_entered(_body: Node2D) -> void:
	hit.emit()  # Emite o sinal de que o jogador foi atingido
	$CollisionShape2D.set_deferred("disabled", true)  # Desativa a colisão temporariamente
	start(Vector2(100, 100))  # Define uma posição inicial segura para o jogador

func start(pos):
	position = pos
	show()
