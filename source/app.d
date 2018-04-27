import dsfml.window;
import dsfml.system;
import dsfml.graphics;

import game;

import std.random : Random, unpredictableSeed;
import std.stdio : writeln;
import std.conv : to;

void main()
{
	auto game = new Game();
	game.run();
}
