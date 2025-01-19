package main

import "core:fmt"

main :: proc() {
	a: [dynamic]bool


	fmt.println(a)

	assign_at(&a, 1, false)

	a[1] = false

	fmt.println(a)

}
