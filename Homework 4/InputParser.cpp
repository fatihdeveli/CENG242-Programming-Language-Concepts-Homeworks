#include"InputParser.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/

Game* InputParser::parseGame() {
	int size, coordX, coordY, maxTurns, numPlayers;
	std::cin >> size >> coordX >> coordY >> maxTurns >> numPlayers;

	auto game = new Game(maxTurns, size, Coordinate(coordX, coordY));

	for (int i = 0; i < numPlayers; i++) {
		int id, x, y;
		std::string teamStr, cls;
		std::cin >> cls >> teamStr >> x >> y;
		Team team = teamStr == "BARBARIANS" ? BARBARIANS : KNIGHTS;
		game->addPlayer(id, x, y, team, cls);
	}

	return game;
}