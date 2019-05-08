#include"Priest.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Priest::Priest(uint id, int x, int y, Team team) : Player(id, x, y, team) {
    attackDamage = 0;
    healPower = 50;
    maxHP = 150;
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
    return std::vector<Coordinate>();
}

std::vector<Coordinate> Priest::getMoveableCoordinates() {
    return std::vector<Coordinate>();
}

std::vector<Coordinate> Priest::getHealableCoordinates() {
    return std::vector<Coordinate>();
}
