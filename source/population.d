import dsfml.graphics;
import dsfml.window;
import dsfml.system;

import std.conv : to;
import std.stdio : writeln;
import std.math;
import std.random : Random, unpredictableSeed, uniform;

import rocket;

class Population
{
	immutable int popsize = 100;
	Rocket[popsize] rockets;

	this(Vector2i displaySize)
	{
		foreach(i; 0 .. this.popsize)
		{
			this.rockets[i] = new Rocket(displaySize);
			writeln(&this.rockets[i]);
		}
	}

	void run(RenderWindow window)
	{
		foreach (i; 0 .. this.popsize)
		{
			this.rockets[i].update();
			this.rockets[i].draw(window);
		}
	}
}