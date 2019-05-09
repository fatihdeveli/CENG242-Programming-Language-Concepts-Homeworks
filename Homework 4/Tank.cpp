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
    return std::vector<Coordinate>();
}

std::vector<Coordinate> Tank::getMoveableCoordinates() {
    return std::vector<Coordinate>();
}

std::vector<Coordinate> Tank::getHealableCoordinates() {
    return std::vector<Coordinate>();
}
