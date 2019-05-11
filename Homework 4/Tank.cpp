#include"Tank.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Tank::Tank(uint id,int x, int y, Team team) :
Player(id, x, y, team) {
    attackDamage = 25;
    healPower = 0;
    HP = maxHP = 1000;
    priorities = {TO_ENEMY, ATTACK, CHEST};
    if (team == BARBARIANS) {
        abbreviation = "TA";
    }
    else {
        abbreviation = "ta";
    }
}

int Tank::getAttackDamage() const {
    return attackDamage;
}

int Tank::getHealPower() const {
    return healPower;
}

int Tank::getMaxHP() const {
    return maxHP;
}

std::vector<Goal> Tank::getGoalPriorityList() {
    return priorities;
}

const std::string Tank::getClassAbbreviation() const {
    return abbreviation;
}

std::vector<Coordinate> Tank::getAttackableCoordinates() {
    // Can attack to adjacent up, down, left or right
    std::vector<Coordinate> attackables;
    attackables.push_back(coordinate + Coordinate(1, 0));
    attackables.push_back(coordinate + Coordinate(-1, 0));
    attackables.push_back(coordinate + Coordinate(0, 1));
    attackables.push_back(coordinate + Coordinate(0, -1));
    return attackables;
}

std::vector<Coordinate> Tank::getMoveableCoordinates() {
    // Can move to adjacent up, down, left or right
    std::vector<Coordinate> movables;
    movables.push_back(coordinate + Coordinate(1, 0));
    movables.push_back(coordinate + Coordinate(-1, 0));
    movables.push_back(coordinate + Coordinate(0, 1));
    movables.push_back(coordinate + Coordinate(0, -1));
    return movables;
}

std::vector<Coordinate> Tank::getHealableCoordinates() {
    return std::vector<Coordinate>(); // Tanks cannot heal.
}
