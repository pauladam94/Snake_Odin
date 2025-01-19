package main

EntityHandle :: int

ECS :: struct {
	connections:         [dynamic]ConnectionComponent,
	nodes:               [dynamic]NodeComponent,
	posisionts:          [dynamic]PositionComponent,
	circles:             [dynamic]CircleComponent,
	// All entities
	entities:            [dynamic]EntityHandle,
	// Which entites have which component
	entities_components: [dynamic]ComponentTypeSet,
}

new_id :: proc(using ecs: ECS) -> EntityHandle {
	present: [dynamic]bool
	defer delete(present)

	for id in entities {
		if id < len(entities) {
			assign_at(&present, id, true)
		}
	}

	for is_here, i in present {
		if !is_here {
			return i
		}
	}
	return len(entities)
}

new_entity :: proc(components: []ComponentType) {
	id := new_id(ecs)
}
