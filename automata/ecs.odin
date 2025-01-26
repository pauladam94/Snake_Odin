package main

import "core:fmt"
import "core:reflect"

EntityHandle :: int

Components :: struct {
	connections: [dynamic]Maybe(ConnectionComponent),
	nodes:       [dynamic]Maybe(NodeComponent),
	positions:   [dynamic]Maybe(PositionComponent),
	circles:     [dynamic]Maybe(CircleComponent),
	healths:     [dynamic]Maybe(HealthComponent),
	players:     [dynamic]Maybe(PlayerComponent),
	bounds:      [dynamic]Maybe(BoundComponent),
}
ECS :: struct {
	using components: Components,
	// All entities
	entities:         [dynamic]EntityHandle,
}

new_id :: proc() -> EntityHandle {
	using ecs
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

	append(&connections, nil)
	append(&nodes, nil)
	append(&positions, nil)
	append(&circles, nil)
	append(&healths, nil)
	append(&players, nil)
	append(&bounds, nil)
	return len(entities)
}

new_entity :: proc() -> (id: EntityHandle) {
	id = new_id()
	fmt.println("new id: ", id)
	append(&ecs.entities, id)
	return
}

set_component :: proc {
	set_connection_component,
	set_node_component,
	set_position_component,
	set_circle_component,
	set_player_component,
	set_bound_component,
}

delete_ecs :: proc() {
	using ecs
	delete_dynamic_array(connections)
	delete_dynamic_array(nodes)
	delete_dynamic_array(positions)
	delete_dynamic_array(entities)
}
