enum Colors {
	RED,
	BLUE,
}

static func to_color(enum_value):
	match enum_value:
		Colors.RED:
			return Color(1, 0, 0)
		Colors.BLUE:
			return Color(0, 0, 1)
	
	return Color(1, 1, 1)		