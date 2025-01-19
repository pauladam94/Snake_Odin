package main

apply_system :: proc(using ecs: ECS) {
	using ComponentType
	for id in entities {
		switch {
		case Node in entities_components[id] &&
		     Circle in entities_components[id]:
		}
	}
}
