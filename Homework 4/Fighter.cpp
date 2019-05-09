#include"Fighter.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Fighter::Fighter(uint id, int x, int y, Team team) : Player(id, x, y, team) {
    attackDamage = 200;
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
    return std::vector<Coordinate>();
}

std::vector<Coordinate> Fighter::getMoveableCoordinates() {
    return std::vector<Coordinate>();
}

std::vector<Coordinate> Fighter::getHealableCoordinates() {
    return std::vector<Coordinate>();
}
