#include"Fighter.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Fighter::Fighter(uint id, int x, int y, Team team) : Player(id, x, y, team) {
    attackDamage = 100;
    healPower = 0;
    HP = maxHP = 400;
    priorities = {ATTACK, TO_ENEMY, CHEST};
    if (team == BARBARIANS) {
        abbreviation = "FI";
    }
    else {
        abbreviation = "fi";
    }
}

int Fighter::getAttackDamage() const {
    return attackDamage;
}

int Fighter::getHealPower() const {
    return healPower;
}

int Fighter::getMaxHP() const {
    return maxHP;
}

std::vector<Goal> Fighter::getGoalPriorityList() {
    return priorities;
}

const std::string Fighter::getClassAbbreviation() const {
    return abbreviation;
}

std::vector<Coordinate> Fighter::getAttackableCoordinates() {
    // Can attack to adjacent up, down, left or right
    std::vector<Coordinate> attackables;
    attackables.push_back(coordinate + Coordinate(1, 0));
    attackables.push_back(coordinate + Coordinate(-1, 0));
    attackables.push_back(coordinate + Coordinate(0, 1));
    attackables.push_back(coordinate + Coordinate(0, -1));
    return attackables;
}

std::vector<Coordinate> Fighter::getMoveableCoordinates() {
    // Can move to adjacent up, down, left or right
    std::vector<Coordinate> movables;
    movables.push_back(coordinate + Coordinate(1, 0));
    movables.push_back(coordinate + Coordinate(-1, 0));
    movables.push_back(coordinate + Coordinate(0, 1));
    movables.push_back(coordinate + Coordinate(0, -1));
    return movables;
}

std::vector<Coordinate> Fighter::getHealableCoordinates() {
    return std::vector<Coordinate>(); // Fighters cannot heal.
}
