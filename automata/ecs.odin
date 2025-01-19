package main

EntityHandle :: int

ECS :: struct {
	connections:         [dynamic]ConnectionComponent,
	nodes:               [dynamic]NodeComponent,
	positions:           [dynamic]PositionComponent,
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

new_entity :: proc() -> (id: EntityHandle) {
	id = new_id(ecs)
	append(&ecs.entities, id)
	append(&ecs.entities_components, nil)
	return
}

entity_add_component :: proc(entity: EntityHandle, component: ComponentUnion) {

}

entity_set_component :: proc(entity: EntityHandle, component: ComponentUnion) {
}

delete_ecs :: proc() {
	using ecs
	delete_dynamic_array(connections)
	delete_dynamic_array(nodes)
	delete_dynamic_array(positions)
	delete_dynamic_array(entities)
	delete_dynamic_array(entities_components)
}
