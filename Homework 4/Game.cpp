#include <limits>
#include"Game.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/

Game::Game(uint maxTurnNumber, uint boardSize, Coordinate chest) :
board(boardSize, nullptr, chest) {
	this->maxTurnNumber = maxTurnNumber;
	players = std::vector<Player*>();
	board.setPlayers(&players);
	turnNumber = 0;
}

Game::~Game() {
	for (Player* p : players) {
		delete p;
	}
}


void Game::addPlayer(int id, int x, int y, Team team, std::string cls) {
	Player* p = nullptr;
	if (cls == "ARCHER") {
		p = new Archer(id, x, y, team);
	}
	else if (cls == "FIGHTER") {
		p = new Fighter(id, x, y, team);
	}
	else if (cls == "PRIEST") {
		p = new Priest(id, x, y, team);
	}
	else if (cls == "SCOUT") {
		p = new Scout(id, x, y, team);
	}
	else if (cls == "TANK") {
		p = new Tank(id, x, y, team);
	}
	players.push_back(p);
}


bool Game::isGameEnded() {
	Coordinate chest = board.getChestCoordinates();
	bool aliveBarbarianExists = false;
	bool aliveKnightExists = false;
	bool chestCaptured = false;

	for (Player *p : players) {
	    if (p == nullptr)
	        continue;
		if (p->getTeam() == BARBARIANS && !p->isDead()) {
			aliveBarbarianExists = true;

			// Check if the barbarian has reached to the chest.
			if (p->getCoord() == chest && p->getTeam() == BARBARIANS) {
			    chestCaptured = true;
				break;
			}
		}
		else if (!p->isDead()) {
			aliveKnightExists = true;
		}
	}

	if (!aliveBarbarianExists || !aliveKnightExists || chestCaptured || turnNumber == maxTurnNumber) {
	    std::cout << "Game ended at turn " << turnNumber << ". ";
	    if (chestCaptured) {
	        std::cout << "Chest captured. Barbarian victory.";
	    }
	    else if (!aliveBarbarianExists) {
	        std::cout << "All barbarians dead. Knight victory.";
	    }
	    else if (!aliveKnightExists){
            std::cout << "All knights dead. Barbarian victory.";
        }
	    else if (turnNumber == maxTurnNumber) {
	        std::cout << "Maximum turn number reached.";
	    }
	    std::cout << std::endl;
	    return true;
	}
	return false;
}


void Game::playTurn() {
    std::cout << "Turn " << ++turnNumber << " has started." << std::endl;
	uint lastPlayed = 0; // ID of the last player who played a turn.
	for (auto & player : players) {
	    if (player == nullptr)
	        continue;

		// Find the smallest id that has not played.
		Player* nextPlayer = nullptr;
		uint smallest = std::numeric_limits<uint>::max();
		for (Player* p : players) {
		    if (p == nullptr) continue;
			uint ID = p->getID();
			if (ID > lastPlayed && ID < smallest) {
				smallest = ID;
				nextPlayer = p;
			}
		}
		lastPlayed = nextPlayer->getID();

		playTurnForPlayer(nextPlayer);
	}
}


Goal Game::playTurnForPlayer(Player* player) {
    if (player->isDead()) {
        std::cout << "Player " << player->getBoardID() << " has died." << std::endl;
        for (auto & i : players) {
            if (i == player)
                i = nullptr;
        }
        delete player;
        return NO_GOAL;
    }

    for (Goal goal : player->getGoalPriorityList()) {
        if (goal == ATTACK) {
            // Keep a list of enemies, attack the player with lowest ID
            std::vector<Player*> enemies;

            for (Coordinate c : player->getAttackableCoordinates()) {
                if (!board.isCoordinateInBoard(c)) // Coordinate invalid
                    continue;

                Player* playerOnCoordinate = board.getPlayerOnCoordinate(c);
                if (playerOnCoordinate == nullptr) // Coordinate is empty
                    continue;
                if (playerOnCoordinate->getTeam() == player->getTeam()) // Ally
                    continue;

                // If above conditions failed, then there is an attackable enemy. Put the
                // enemy in enemies list to pick the one with smallest id amongst them to attack.
                enemies.push_back(playerOnCoordinate);
            }

            // Select the enemy with smallest ID number and attack.
            Player* enemyToAttack = playerWithSmallestID(enemies);

            if (enemyToAttack) { // Found an enemy to attack
                player->attack(enemyToAttack);
                return ATTACK;
            }

            // Else: enemyToAttack is null, then there is no suitable enemy to attack.
            // Continue with other goals in the priority list.
            continue;
        }

        else if (goal == CHEST) {
            Coordinate chest = board.getChestCoordinates();
            int currentDistance = player->getCoord() - chest;

            // Keep the possible coordinates whose distances to chest are shorter than the current.
            std::vector<Coordinate> possibleCoordinates;
            for (Coordinate c : player->getMoveableCoordinates()) {
                if (c - chest < currentDistance) {
                    // Check if the coordinate is available
                    if (board.isPlayerOnCoordinate(c))
                        continue;
                    else
                        possibleCoordinates.push_back(c);
                }
            }

            Coordinate coordinateToMove = findMoveCoordinate(possibleCoordinates,
                    player->getCoord(), chest);
            if (coordinateToMove == Coordinate(-1, -1)) // No coordinate is possible
                continue;
            // Else: found a valid coordinate
            player->movePlayerToCoordinate(coordinateToMove);
            return CHEST;
        }

        else if (goal == TO_ENEMY) {
            // Find the closest distance
            int closestDistance = std::numeric_limits<int>::max();
            for (Player* p : players) {
                if (p == nullptr) // p is null if player is dead
                    continue;
                if (p->getTeam() != player->getTeam()) { // Look for enemies
                    int distance = p->getCoord() - player->getCoord();
                    if (distance <= closestDistance) {
                        closestDistance = distance;
                    }
                }
            }

            // Select the enemies with the closest distance
            std::vector<Player*> closestEnemies;
            for (Player* p : players) {
                if (p == nullptr) // p is null if player is dead
                    continue;
                if (p->getTeam() != player->getTeam()) {
                    int distance = p->getCoord() - player->getCoord();
                    if (distance == closestDistance) {
                        closestEnemies.push_back(p);
                    }
                }
            }

            // There might be multiple enemies with the same smallest distance.
            // In this case, select the enemy with the smallest ID.
            Player* enemyToMove = playerWithSmallestID(closestEnemies);

            // Find the squares that ara closer to the target.
            int currentDistance = player->getCoord() - enemyToMove->getCoord();
            std::vector<Coordinate> possibleCoordinates;
            for (Coordinate c : player->getMoveableCoordinates()) {
                if (c - enemyToMove->getCoord() < currentDistance) {
                    // Check if the coordinate is available
                    if (board.isPlayerOnCoordinate(c))
                        continue;
                    else
                        possibleCoordinates.push_back(c);
                }
            }

            Coordinate coordinateToMove = findMoveCoordinate(possibleCoordinates,
                    player->getCoord(), enemyToMove->getCoord());
            if (coordinateToMove == Coordinate(-1, -1)) // No coordinate is possible
                continue;
            // Else: found a valid coordinate
            player->movePlayerToCoordinate(coordinateToMove);
            return TO_ENEMY;

        }

        else if (goal == TO_ALLY) {
            // Find the closest distance
            int closestDistance = std::numeric_limits<int>::max();
            for (Player* p : players) {
                if (p == nullptr) // p is null if player is dead
                    continue;
                if (p == player) // Skip self
                    continue;
                if (p->getTeam() == player->getTeam()) { // Look for allies
                    int distance = p->getCoord() - player->getCoord();
                    if (distance <= closestDistance) {
                        closestDistance = distance;
                    }
                }
            }

            // Select the allies with the closest distance
            std::vector<Player*> closestAllies;
            for (Player* p : players) {
                if (p == nullptr) // p is null if player is dead
                    continue;
                if (p->getTeam() == player->getTeam()) {
                    int distance = p->getCoord() - player->getCoord();
                    if (distance == closestDistance) {
                        closestAllies.push_back(p);
                    }
                }
            }

            // There might be multiple enemies with the same smallest distance.
            // In this case, select the enemy with the smallest ID.
            Player* allyToMove = playerWithSmallestID(closestAllies);

            // Find the square to move to.
            int currentDistance = player->getCoord() - allyToMove->getCoord();
            std::vector<Coordinate> possibleCoordinates;
            for (Coordinate c : player->getMoveableCoordinates()) {
                if (c - allyToMove->getCoord() < currentDistance) {
                    // Check if the coordinate is available
                    if (board.isPlayerOnCoordinate(c))
                        continue;
                    else
                        possibleCoordinates.push_back(c);
                }
            }

            Coordinate coordinateToMove = findMoveCoordinate(possibleCoordinates,
                    player->getCoord(), allyToMove->getCoord());
            if (coordinateToMove == Coordinate(-1, -1)) // No coordinate is possible
                continue;
            // Else: found a valid coordinate
            player->movePlayerToCoordinate(coordinateToMove);
            return TO_ALLY;
        }

        else if (goal == HEAL) {
            bool healed = false; // Return value will be HEAL if someone is healed.
            for (Coordinate c : player->getHealableCoordinates()) {
                Player* p = board.getPlayerOnCoordinate(c);
                if (p != nullptr && p->getTeam() == player->getTeam()) { // Only heal allies
                    player->heal(p);
                    healed = true;
                }
            }
            if (healed)
                return HEAL;
            continue; // Else: Failed to heal anyone, continue with other goals
        }
    }

    // If the player failed to achieve any of the goals, return NO_GOAL and do nothing.
    return NO_GOAL;
}

Player* Game::playerWithSmallestID(std::vector<Player*>& list) {
    uint smallestID = std::numeric_limits<uint>::max();
    Player* returnVal = nullptr;
    for (Player* p : list) {
        if (p == nullptr) // p is null if player is dead
            continue;
        if (p->getID() < smallestID) {
            smallestID = p->getID();
            returnVal = p;
        }
    }
    return returnVal;
}

Coordinate Game::findMoveCoordinate(std::vector<Coordinate>& possibleCoordinates,
        Coordinate currentPos, Coordinate target) {
    // More than 2 possible coordinates (with a diagonal). Find the shortest.
    if (possibleCoordinates.size() > 2) {
        Coordinate coordinateToMove(-1,-1);
        int shortest = std::numeric_limits<int>::max();
        for (Coordinate c : possibleCoordinates) {
            if (c - target < shortest) {
                shortest = c - target;
                coordinateToMove = c;
            }
        }
        return coordinateToMove;
    }
    // 2 possible coordinates: If one of them is vertical and the other is horizontal,
    // select the horizontal one. If one of them is diagonal, select diagonal.
    else if (possibleCoordinates.size() == 2) {
        // If vertical coordinate exists, its distance is shorter.
        Coordinate c1 = possibleCoordinates[0];
        Coordinate c2 = possibleCoordinates[1];
        if (c1 - target != c2 - target) { // Vertical coordinate exists
            if (c1 - target < c2 - target)
                return c1;
            else
                return c2;
        }
        else { // Vertical coordinate does not exist.
            if (c1.y == currentPos.y) // Horizontal move
                return c1;
            else // c2 is the horizontal move
                return c2;
        }
    }
    else if (!possibleCoordinates.empty()) { // Only one possible coordinate
        return possibleCoordinates[0];
    }
    else {
        return {-1, -1};
    }
}
