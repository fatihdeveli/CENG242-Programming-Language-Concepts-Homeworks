#include"Archer.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Archer::Archer(uint id, int x, int y, Team team) : Player(id, x, y, team) {
    attackDamage = 50;
    healPower = 0;
    maxHP = 200;
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
    return std::vector<Coordinate>();
}

std::vector<Coordinate> Archer::getMoveableCoordinates() {
    return std::vector<Coordinate>();
}

std::vector<Coordinate> Archer::getHealableCoordinates() {
    return std::vector<Coordinate>();
}
