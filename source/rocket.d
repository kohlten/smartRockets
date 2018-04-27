import dsfml.graphics;
import dsfml.window;
import dsfml.system;

import std.conv : to;
import std.stdio : writeln;
import std.math;
import std.random : Random, unpredictableSeed, uniform;

import helpFuncs;

class Rocket
{
	RectangleShape rocket;
	Vector2i displaySize;
	Vector2f size;
	Vector2f pos;
	Vector2f vel;
	Vector2f acc;

	this(Vector2i displaySize)
	{
		this.displaySize = displaySize;
		this.rocket = new RectangleShape();
		this.size = Vector2f(50, 10);
		this.rocket.size = this.size;
		this.pos = Vector2f(this.displaySize.x / 2, this.displaySize.y);
		this.rocket.position(this.pos);
		this.rocket.fillColor = Color(255, 255, 255, 150);
		this.vel = randomVector(true);
		this.acc = Vector2f(0, 0);
	}

	void applyForce(Vector2f force)
	{
		this.acc += force;
	}

	void draw(RenderWindow window)
	{
		window.draw(this.rocket);
	}

	void update()
	{
		this.vel += this.acc;
		this.pos += this.vel;
		this.acc *= 0;
		this.rocket = rotateCenter!RectangleShape(this.rocket, getHeading!Vector2f(this.vel));
		this.rocket.position = this.pos;
	}

}
