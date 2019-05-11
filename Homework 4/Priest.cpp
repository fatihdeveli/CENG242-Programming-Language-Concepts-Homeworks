#include"Priest.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Priest::Priest(uint id, int x, int y, Team team) : Player(id, x, y, team) {
    attackDamage = 0;
    healPower = 50;
    HP = maxHP = 150;
    priorities = {HEAL, TO_ALLY, CHEST};
    if (team == BARBARIANS) {
        abbreviation = "PR";
    }
    else {
        abbreviation = "pr";
    }
}

int Priest::getAttackDamage() const {
    return attackDamage;
}

int Priest::getHealPower() const {
    return healPower;
}

int Priest::getMaxHP() const {
    return maxHP;
}

std::vector<Goal> Priest::getGoalPriorityList() {
    return priorities;
}

const std::string Priest::getClassAbbreviation() const {
    return abbreviation;
}

std::vector<Coordinate> Priest::getAttackableCoordinates() {
    return std::vector<Coordinate>(); // Priests cannot attack
}

std::vector<Coordinate> Priest::getMoveableCoordinates() {
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

std::vector<Coordinate> Priest::getHealableCoordinates() {
    // Can heal all adjacent squares
    std::vector<Coordinate> healables;
    healables.push_back(coordinate + Coordinate(-1, -1));
    healables.push_back(coordinate + Coordinate(-1, 0));
    healables.push_back(coordinate + Coordinate(-1, 1));
    healables.push_back(coordinate + Coordinate(0, -1));
    healables.push_back(coordinate + Coordinate(0, 1));
    healables.push_back(coordinate + Coordinate(1, -1));
    healables.push_back(coordinate + Coordinate(1, 0));
    healables.push_back(coordinate + Coordinate(1, 1));
    return healables;
}
