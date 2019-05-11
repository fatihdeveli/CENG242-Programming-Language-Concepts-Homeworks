#include"Scout.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Scout::Scout(uint id, int x, int y, Team team) : Player(id, x, y, team) {
    attackDamage = 25;
    healPower = 0;
    HP = maxHP = 125;
    priorities = {CHEST, TO_ALLY, ATTACK};
    if (team == BARBARIANS) {
        abbreviation = "SC";
    }
    else {
        abbreviation = "sc";
    }
}

int Scout::getAttackDamage() const {
    return attackDamage;
}

int Scout::getHealPower() const {
    return healPower;
}

int Scout::getMaxHP() const {
    return maxHP;
}

std::vector<Goal> Scout::getGoalPriorityList() {
    return priorities;
}

const std::string Scout::getClassAbbreviation() const {
    return abbreviation;
}

std::vector<Coordinate> Scout::getAttackableCoordinates() {
    // Can attack to all adjacent squares
    std::vector<Coordinate> attackables;
    attackables.push_back(coordinate + Coordinate(-1, -1));
    attackables.push_back(coordinate + Coordinate(-1, 0));
    attackables.push_back(coordinate + Coordinate(-1, 1));
    attackables.push_back(coordinate + Coordinate(0, -1));
    attackables.push_back(coordinate + Coordinate(0, 1));
    attackables.push_back(coordinate + Coordinate(1, -1));
    attackables.push_back(coordinate + Coordinate(1, 0));
    attackables.push_back(coordinate + Coordinate(1, 1));
    return attackables;
}

std::vector<Coordinate> Scout::getMoveableCoordinates() {
    // Can move to all adjacent squares
    std::vector<Coordinate> movables;
    movables.push_back(coordinate + Coordinate(-1, -1));
    movables.push_back(coordinate + Coordinate(-1, 0));
    movables.push_back(coordinate + Coordinate(-1, 1));
    movables.push_back(coordinate + Coordinate(0, -1));
    movables.push_back(coordinate + Coordinate(0, 1));
    movables.push_back(coordinate + Coordinate(1, -1));
    movables.push_back(coordinate + Coordinate(1, 0));
    movables.push_back(coordinate + Coordinate(1, 1));
    return movables;
}

std::vector<Coordinate> Scout::getHealableCoordinates() {
    return std::vector<Coordinate>(); // Scouts cannot heal
}
