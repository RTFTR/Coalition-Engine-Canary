///@desc Returns a Positive Quotient of the 2 values
///@param {real} a The number to bde divided
///@param {real} a The number to divide
///@return {real}
function Posmod(a,b)
{
	var value = a % b;
	if (value < 0 and b > 0) or (value > 0 and b < 0) 
		value += b;
	return value;
}

///@desc idk but it's for board so don't touch i guess
function point_xy(p_x, p_y)
{
	var angle = image_angle
	
	point_x = ((p_x - x) * dcos(-angle)) - ((p_y - y) * dsin(-angle)) + x
	point_y = ((p_y - y) * dcos(-angle)) + ((p_x - x) * dsin(-angle)) + y
}
