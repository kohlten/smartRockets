import dsfml.graphics;
import dsfml.window;
import dsfml.system;

import std.conv : to;
import std.stdio : writeln;
import std.math;
import std.random : uniform;

import rocket;
import helpFuncs;

class Population
{
	immutable int	popsize = 500;
	Rocket[popsize]	rockets;
	Rocket[]		matingPool;
	Vector2i		displaySize;
	int				count;

	this(Vector2i displaySize)
	{
		this.displaySize = displaySize;
		foreach(i; 0 .. this.popsize)
			this.rockets[i] = new Rocket(this.displaySize);
	}

	void run(int frames, RenderWindow window, CircleShape circle, RectangleShape[] obs)
	{
		foreach (i; 0 .. this.popsize)
		{
			this.rockets[i].update(this.count, circle, obs);
			this.rockets[i].draw(window);
		}
		if (frames % 3 == 0)
			this.count++;
	}

	void evaluate(Vector2f targetPos)
	{
		float maxfit;
		float maxlen;

		foreach (i; 0 .. this.popsize)
		{
			this.rockets[i].calcFitness(targetPos);
			if (this.rockets[i].fitness > maxfit)
				maxfit = this.rockets[i].fitness;
			if (this.rockets[i].path.length > maxlen)
				maxlen = this.rockets[i].path.length;
		}

		this.matingPool = [];
		foreach (i; 0 .. this.popsize)
		{
			float n = this.rockets[i].fitness * 100;
			if (this.rockets[i].path.length > maxlen - 50 && this.rockets[i].reached)
				n += maxlen - this.rockets[i].path.length;
			foreach (j; 0 .. n)
				this.matingPool ~= this.rockets[i];
		}
	}

	void selection()
	{
		Rocket[] newRockets;

		foreach (i; 0 .. this.popsize)
		{
			DNA p1 = getRandomObject!Rocket(this.matingPool).dna;
			DNA p2 = getRandomObject!Rocket(this.matingPool).dna;
			DNA child = p1.crossover(p2);
			child.mutation();
			newRockets ~= new Rocket(this.displaySize, child);
		}
		this.rockets = newRockets;
	}

	bool done()
	{
		foreach (rocket; rockets)
			if (!rocket.reached && !rocket.hitob)
				return false;
		return true;
	}
}