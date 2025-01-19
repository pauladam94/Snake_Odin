package main

load_level1 :: proc() {
a := automata_init(
					{0, 1, 2, 3, 4},
		{
			Transition{0, "a", 1},
			Transition{1, "a", 2},
			Transition{2, "a", 3},
			Transition{2, "b", 1},
			Transition{3, "a", 1},
			Transition{1, "b", 4},
			Transition{4, "b", 1},
		},
	)
}
