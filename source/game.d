import dsfml.graphics;
import dsfml.window;
import dsfml.system;

import std.conv : to;
import std.random : Random, unpredictableSeed, uniform;
import std.stdio : writeln;

import population;

class Game
{
	RenderWindow	window;
	Vector2i		size;
	ContextSettings	settings;
	Color			color;

	Population pop;

	this()
	{
		this.color = Color(0, 0, 0);
		this.size = Vector2i(400, 300);
		this.window = new RenderWindow(VideoMode(this.size.x, this.size.y), "Smart Rockets");
		this.window.setFramerateLimit(60);
		this.pop = new Population(this.size);
	}

	void run()
	{
		while (this.window.isOpen())
		{
			this.getEvents();
			this.window.clear(this.color);
			this.pop.run(this.window);
			this.window.display();
		}
	}

	void getEvents()
	{
		Event event;
		while (this.window.pollEvent(event))
		{
			if (event.type == Event.EventType.Closed)
				window.close();
		}
	}
}