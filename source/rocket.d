import dsfml.graphics;
import dsfml.window;
import dsfml.system;

import std.conv : to;
import std.stdio : writeln;
import std.math;
import std.random : Random, unpredictableSeed, uniform;

import helpFuncs;

immutable int lifespan = 1200;

class DNA
{
	Vector2f[lifespan] genes;

	this(Vector2f[] genes = null)
	{
		if (genes is null)
			foreach (i; 0 .. lifespan)
				this.genes[i] = this.newGene();
		else
			this.genes = genes;
	}

	DNA crossover(DNA partner)
	{
		Vector2f[lifespan] newgenes; 
		ulong mid = uniform(0, this.genes.length);

		foreach(i; 0 .. lifespan)
		{
			if (i < mid)
				newgenes[i] = this.genes[i];
			else
				newgenes[i] = partner.genes[i];
		}
		return new DNA(newgenes);
	}

	void mutation()
	{
		foreach (i; 0 .. this.genes.length)
		{
			auto val = uniform(0, 100);
			if (val < 5)
				this.genes[i] = this.newGene();
		}
	}

	Vector2f newGene()
	{
		Vector2f gene = randomVector!Vector2f();
		gene = setMag(gene, 0.3);
		return gene;
	}


}

class Rocket
{
	RectangleShape		rocket;
	Vertex[]			path;

	Vector2i			displaySize;
	Vector2f			size;
	Vector2f			pos;
	Vector2f			vel;
	Vector2f			acc;
	
	float 				fitness;
	
	DNA dna;	
	
	bool 				reached;
	bool 				hitob;

	this(Vector2i displaySize, DNA dna = null)
	{
		this.rocket = new RectangleShape();

		this.displaySize = displaySize;

		this.size = Vector2f(10, 1);
		this.rocket.size = this.size;

		this.pos = Vector2f(this.displaySize.x / 2, this.displaySize.y);

		this.rocket.position(this.pos);
		this.rocket.fillColor = Color(255, 255, 255, 150);

		this.vel = Vector2f(0, 0);
		this.acc = Vector2f(0, 0);

		if (dna is null)
			this.dna = new DNA();
		else
			this.dna = dna;
	}

	private void applyForce(Vector2f force)
	{
		this.acc += force;
	}

	void draw(RenderWindow window)
	{
		//Uncomment to see the rockets
		//window.draw(this.rocket);
		window.draw(this.path, PrimitiveType.LinesStrip);
	}

	void update(int count, CircleShape circle, RectangleShape[] obs)
	{
		if (collidesRect(this.rocket, circle))
			this.reached = true;
		
		foreach (ob; obs)
		{
			if (collidesRect(this.rocket, ob))
				this.hitob = true;
		}
		if (count < lifespan)
			this.applyForce(this.dna.genes[count]);

		if (!this.reached && !this.hitob)
		{
			this.vel += this.acc;
			this.pos += this.vel;
			this.acc *= 0;

			this.rocket = rotateCenter!RectangleShape(this.rocket,
				getHeading!Vector2f(this.vel));
			this.rocket.position = this.pos;
			this.path ~= Vertex(this.pos, Color(0, 255, 0, 50));
		}
	}

	void calcFitness(Vector2f targetPos)
	{
		float d = dist!Vector2f(this.pos, targetPos);
		this.fitness = map(d, 0, this.displaySize.x, this.displaySize.x, 0);
		if (this.reached)
			this.fitness *= 50;
		else if (this.hitob)
			this.fitness /= 10;
	}

}
