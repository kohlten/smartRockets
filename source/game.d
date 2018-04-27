import dsfml.graphics;
import dsfml.window;
import dsfml.system;

import std.conv : to;
import std.random : Random, unpredictableSeed, uniform;
import std.stdio : writeln;
import std.datetime : Duration;

import population;

class Game
{
	RenderWindow	window;
	Vector2i		size;
	ContextSettings	*options;
	Color			color;
	CircleShape		target;
	RectangleShape[]obs;
	Clock			clock;
	Duration		last;
	long 			iter;
	int 			frames;


	Population pop;

	this()
	{
		this.color	 = 	Color(0, 0, 0);
		this.size  	 =	Vector2i(800, 600);

		this.options = 	new ContextSettings();
		this.options.antialiasingLevel = 8;

		this.window  = 	new RenderWindow(VideoMode(this.size.x, this.size.y), "Smart Rockets", Window.Style.DefaultStyle, *options);
		this.pop 	 =	new Population(this.size);
		this.target  = 	new CircleShape(6);
		this.clock 	 = 	new Clock();

		foreach (i; 0 .. 5)
			this.obs ~= new RectangleShape();
		this.target.position  = Vector2f(this.size.x / 2 - 6, 50);
		this.target.fillColor = Color(255, 0, 0);

		this.obs[0].size = Vector2f(this.size.x / 2, 10);
		this.obs[0].position = Vector2f((this.size.x / 2) - (this.obs[0].size.x / 2), this.size.y / 3);

		this.obs[1].size = Vector2f(this.size.x, 5);
		this.obs[2].size = Vector2f(5, this.size.y);
		this.obs[3].size = Vector2f(10, this.size.y);
		this.obs[4].size = Vector2f(this.size.x, 10);

		this.obs[3].position = Vector2f(this.size.x, 0);
		this.obs[4].position = Vector2f(0, this.size.y + 100);

		foreach (i; 0 .. 5)
			this.obs[0].fillColor = Color(255, 255, 255);

		this.window.setFramerateLimit(120);

		last = clock.getElapsedTime();
	}

	void run()
	{
		while (this.window.isOpen())
		{
			this.getEvents();
			if (this.pop.count == 250 || this.pop.done())
			{
				writeln(this.iter);
				this.pop.evaluate(this.target.position);
				this.pop.selection();
				this.pop.count = 0;
				this.iter++;
			}

			/*Duration current = clock.getElapsedTime();
			if ((current - last).total!"seconds" >= 1)
			{
				writeln(frames);
				last = current;
				frames = 0;
			}*/
			
			this.window.clear(this.color);

			this.window.draw(this.target);
			foreach (ob; this.obs)
				this.window.draw(ob);
			this.pop.run(this.frames, this.window, this.target, this.obs);
			this.window.display();

			this.frames++;
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