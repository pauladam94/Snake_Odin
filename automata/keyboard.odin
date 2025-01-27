package main

import rl "vendor:raylib"

KeyboardLayout :: enum {
	AZERTY,
	QWERTY,
}

keyboard_layout: KeyboardLayout : .AZERTY

all_keys: []rl.KeyboardKey = {.A, .B, .C, .D, .E, .F, .G, .H, .SPACE}
keymap: map[rl.KeyboardKey]string = {
	.A     = "a",
	.B     = "b",
	.C     = "c",
	.D     = "d",
	.E     = "e",
	.F     = "f",
	.G     = "g",
	.H     = "h",
	.I     = "i",
	.R     = "r",
	.SPACE = " ",
}
when keyboard_layout == .AZERTY {

} else when keyboard_layout == .QWERTY {

}
