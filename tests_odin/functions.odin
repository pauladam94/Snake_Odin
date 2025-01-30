package main

import "core:fmt"

HigherOrder :: struct {
	transi: f32,
	f:      proc(),
}

test := 32

print_hello_world :: proc() {
	fmt.println("Heyy world !")
}

main :: proc() {
	a := HigherOrder{1., print_hello_world}

	// NOT ALLOWED
	// b := 4
	// test_fun :: proc() {
	// 	fmt.println("b = ", b)
	// }

	test_fun2 :: proc() {
		test += 1
		fmt.println("test = ", test)
	}
	b := HigherOrder{0., test_fun2}

	a.f()

	b.f()

	b.f()
}
