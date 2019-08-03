enum Colors {
	RED,
	BLUE,
}

static func to_color(enum_value):
	match enum_value:
		Colors.RED:
			return Color(85.0/256.0, 30.6/256.0, 22.0/256.0)
		Colors.BLUE:
			return Color(12.9/256.0, 66.3/256.0, 87.0/256.0)
	
	return Color(1, 1, 1)		