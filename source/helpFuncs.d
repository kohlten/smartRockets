import dsfml.system;

import std.random : uniform;
import std.math;

Vector2f randomVector(bool degrees, int length = 1)
{
	float angle;

	if (degrees)
		angle = uniform(0.0, 360.0);
	else
		angle = uniform(0.0, PI * 2);
	return Vector2f(length * cos(angle), length * sin(angle));
}

T rotateCenter(T)(T object, float degrees)
{
	if (isNaN(degrees))
		degrees = 0;
	object.origin(object.size / 2);
	object.rotation(degrees);
	return object;
}

float getHeading(T)(T vector, bool degrees = true)
{
	if (degrees)
		return atan2(vector.y, vector.x) * 180 / PI;
	else
		return atan2(vector.y, vector.x);
}