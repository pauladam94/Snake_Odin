package main

import "core:fmt"
import "core:math"

HealthComponent :: struct {
	value: f32,
	max:   f32,
}
BossComponent :: struct {
	at: EntityHandle,
}
PlayerComponent :: struct {
	at: EntityHandle,
}
ConnectionComponent :: [dynamic]Connection
Connection :: struct {
	letter:  string,
	link_to: EntityHandle,
}
NodeComponent :: struct {}
CircleComponent :: struct {
	radius: f32,
}
PositionComponent :: struct {
	using pos:     Vec2,
	begin:         Vec2,
	end:           Vec2,
	transition:    f32,
	in_transition: bool,
}
BoundComponent :: struct {
	min: Vec2,
	max: Vec2,
}

append_connection :: proc(entity: EntityHandle, connection: Connection) {
	if connections, ok := &ecs.connections[entity].?; ok {
		append(connections, connection)
	} else {
		set_connection_component(entity, {connection})
	}
}
// Set
set_connection_component :: proc(
	entity: EntityHandle,
	component: ConnectionComponent,
) {
	assign_at(&ecs.connections, entity, component)
}
set_node_component :: proc(entity: EntityHandle, component: NodeComponent) {
	assign_at(&ecs.nodes, entity, component)
}
set_position_component :: proc(
	entity: EntityHandle,
	component: PositionComponent,
) {
	assign_at(&ecs.positions, entity, component)
}
set_circle_component :: proc(
	entity: EntityHandle,
	component: CircleComponent,
) {
	assign_at(&ecs.circles, entity, component)
}
set_player_component :: proc(
	entity: EntityHandle,
	component: PlayerComponent,
) {
	assign_at(&ecs.players, entity, component)
}
set_bound_component :: proc(entity: EntityHandle, component: BoundComponent) {
	assign_at(&ecs.bounds, entity, component)
}
set_boss_component :: proc(entity: EntityHandle, component: BossComponent) {
	assign_at(&ecs.bosses, entity, component)
}
set_health_component :: proc(
	entity: EntityHandle,
	component: HealthComponent,
) {
	assign_at(&ecs.healths, entity, component)
}

// Operation on Component
next_state :: proc(
	connection: ConnectionComponent,
	letter: string,
) -> (
	player: PlayerComponent,
	ok: bool,
) {
	for con in connection {
		if con.letter == letter {
			player = PlayerComponent{con.link_to}
			ok = true
			return
		}
	}
	ok = false
	return
}

nodes_weight :: proc(entity: EntityHandle) -> (weight: f32) {
	using ecs
	l0: f32 = 300
	k: f32 = 10
	mu: f32 = math.pow(k, 6)
	// All connections from entity
	if connections_entity, ok := connections[entity].?; ok {
		for t in connections_entity {
			begin := positions[entity].?
			end := positions[t.link_to].?
			weight += k * math.abs(length(end.pos - begin.pos) - l0)
		}
	}
	// All connection to entity
	for connection, id in connections {
		if con, ok := connection.?; ok {
			for connect in con {
				if connect.link_to == entity {
					begin := positions[id].?
					end := positions[entity].?
					weight += k * math.abs(length(end.pos - begin.pos) - l0)
				}
			}
		}
	}
	for p1_maybe, id1 in positions {
		p1, is_pos := p1_maybe.?
		_, ok_node1 := nodes[id1].?
		if is_pos && ok_node1 {
			for p2_maybe, id2 in positions {
				p2, is_pos := p2_maybe.?
				_, ok_node2 := nodes[id2].?
				if is_pos && ok_node2 && p1 != p2 && id1 != id2 {
					weight += mu / length(p1.pos - p2.pos)
				}
			}
		}
	}

	return
}
