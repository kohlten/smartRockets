import dsfml.system;

import std.random;
import std.stdio;
import std.math;

//https://github.com/SFML/SFML/wiki/Source%3A-Simple-Collision-Detection

V randomVector(V)(bool degrees = true, int length = 1)
{
	float angle;

	if (degrees)
		angle = uniform(0.0, 360.0);
	else
		angle = uniform(0.0, PI * 2);
	return V(length * cos(angle), length * sin(angle));
}

O rotateCenter(O)(O object, float degrees)
{
	if (isNaN(degrees))
		degrees = 0;
	object.origin(object.size / 2);
	object.rotation(degrees);
	return object;
}

float getHeading(V)(V vector, bool degrees = true)
{
	if (degrees)
		return atan2(vector.y, vector.x) * 180 / PI;
	else
		return atan2(vector.y, vector.x);
}

float getMag(V)(V pos)
{
	return sqrt(pos.x * pos.x + pos.y * pos.y);
}

V normalize(V)(V pos)
{
	float mag = getMag!(V)(pos);
	if (mag == 0)
		return pos;
	return pos / mag; 
}

V setMag(V)(V pos, float n)
{
	return pos.normalize!(V)() * n;
}

float dist(V)(V v1, V v2)
{
	return hypot(v2.x - v1.x, v2.y - v1.y);
}

N constrain(N)(N n, N low, N high)
{
	return fmax(fmin(n, high), low);
}

N map(N)(N n, N start1, N stop1, N start2, N stop2, bool withinBounds = false)
{
	N newval = (n - start1) / (stop1 - start1) * (stop2 - start2) + start2;
	if (!withinBounds)
		return newval;
	if (start2 < stop2)
		return constrain!(N)(newval, start2, stop2);
	else
		return constrain!(N)(newval, stop2, start2);
}

O getRandomObject(O)(O[] objects)
{
	ulong index = uniform(0, objects.length);
	return (objects[index]);
}

O getRandomObject(O)(O[] objects, Random rng)
{
	ulong index = uniform(0, objects.length, rng);
	return objects[index];
}

V rotatePoint(V)(V point, float angle)
{
	V rotated;
	
	angle *= 0.0174533;
	
	rotated.x = point.x * cos(angle) + point.y * sin(angle);
	rotated.y = -point.x * sin(angle) + point.y * cos(angle);

	return rotated;
}

bool collidesRect(ShapeOne, ShapeTwo)(ShapeOne shapeone, ShapeTwo shapetwo)
{
	if (shapeone.getGlobalBounds().intersects(shapetwo.getGlobalBounds()))
		return true;
	return false;
}
