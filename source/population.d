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
	immutable int	popsize = 1000;
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
		float maxfit = 0;
		float maxlen = 0;
		float leastlen = 0;

		foreach (i; 0 .. this.popsize)
		{
			this.rockets[i].calcFitness(targetPos);
			if (this.rockets[i].fitness > maxfit || maxfit == 0)
				maxfit = this.rockets[i].fitness;
			if (this.rockets[i].reached && (this.rockets[i].fitness < leastlen || leastlen == 0))
				leastlen = this.rockets[i].path.length;
			if (this.rockets[i].path.length > maxlen)
				maxlen = this.rockets[i].path.length;
		}

		this.matingPool = [];
		float low = 0;
		float high = 0;
		float average = 0;
		float num = 0;
		writeln("Least len: ", leastlen);
		foreach (i; 0 .. this.popsize)
		{
			float n = this.rockets[i].fitness * 10;
			if (this.rockets[i].path.length < leastlen + 150 && this.rockets[i].reached)
				n += this.rockets[i].path.length * 10;
			if (n <= 0)
				n = 0;
			if (n < low || low == 0)
				low = n;
			if (n > high || high == 0)
				high = n;
			average += n;
			foreach (j; 0 .. n)
				this.matingPool ~= this.rockets[i];
			num++;
		}
		writeln("Low: ", low);
		writeln("High: ", high);
		writeln("Average: ", average / num);
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
		int amount;
		foreach (rocket; rockets)
			if (!rocket.reached && !rocket.hitob)
				amount++;
		if (amount == 0)
			return true;
		return false;
	}
}