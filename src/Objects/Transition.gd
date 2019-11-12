extends Area2D


export(NodePath) var transitionTo = null 

func _ready():
	assert(transitionTo != null)

func _on_Transition_body_entered(body):
	if body.is_in_group("player"):
		body.transition(get_node(transitionTo))
