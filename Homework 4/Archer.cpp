#include"Archer.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Archer::Archer(uint id, int x, int y, Team team) : Player(id, x, y, team) {
    attackDamage = 50;
    healPower = 0;
    HP = maxHP = 200;
    priorities = {ATTACK};
    if (team == BARBARIANS) {
        abbreviation = "AR";
    }
    else {
        abbreviation = "ar";
    }
}

int Archer::getAttackDamage() const {
    return attackDamage;
}

int Archer::getHealPower() const {
    return healPower;
}

int Archer::getMaxHP() const {
    return maxHP;
}

std::vector<Goal> Archer::getGoalPriorityList() {
    return priorities;
}

const std::string Archer::getClassAbbreviation() const {
    return abbreviation;
}

std::vector<Coordinate> Archer::getAttackableCoordinates() {
    // Archers can attack to a range of 2 squares directly up, down, left, or right
    std::vector<Coordinate> attackables;
    attackables.push_back(coordinate + Coordinate(1, 0));
    attackables.push_back(coordinate + Coordinate(2, 0));
    attackables.push_back(coordinate + Coordinate(-1, 0));
    attackables.push_back(coordinate + Coordinate(-2, 0));
    attackables.push_back(coordinate + Coordinate(0, 1));
    attackables.push_back(coordinate + Coordinate(0, 2));
    attackables.push_back(coordinate + Coordinate(0, -1));
    attackables.push_back(coordinate + Coordinate(0, -2));
    return attackables;
}

std::vector<Coordinate> Archer::getMoveableCoordinates() {
    return std::vector<Coordinate>(); // Archers cannot move
}

std::vector<Coordinate> Archer::getHealableCoordinates() {
    return std::vector<Coordinate>(); // Archers cannot heal
}
