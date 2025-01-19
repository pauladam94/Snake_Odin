package main

import "core:fmt"

// Index of the entity
void :: struct {}
ComponentTypeSet :: map[ComponentType]void

HealthComponent :: struct {}
BossComponent :: struct {}
PlayerComponent :: struct {}
ConnectionComponent :: struct {
	link_to: EntityHandle,
}
NodeComponent :: struct {}
CircleComponent :: struct {
	radius: f32,
}
PositionComponent :: struct {
	using pos: Vec2,
}
ComponentType :: enum {
	Connection,
	Node,
	Position,
	Circle,
	Player,
	Boss,
	Health,
}
ComponentUnion :: union #no_nil {
	ConnectionComponent,
	NodeComponent,
	PositionComponent,
	CircleComponent,
	PlayerComponent,
	HealthComponent,
}

component_type :: proc(component_union: ComponentUnion) -> ComponentType {
	using ComponentType
	switch v in component_union {
	case ConnectionComponent:
		return Connection
	case NodeComponent:
		return Node
	case PositionComponent:
		return Position
	case CircleComponent:
		return Circle
	case PlayerComponent:
		return Player
	case HealthComponent:
		return Health
	case:
		fmt.println("Component union should not be nil")
		return nil
	}
}

physics_system :: proc() {}
