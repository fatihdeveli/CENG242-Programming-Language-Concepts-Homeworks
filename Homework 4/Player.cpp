#include"Player.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Player::Player(uint id, int x, int y, Team team) :
id(id), coordinate(x,y), team(team) {

}

uint Player::getID() const {
    return id;
}

const Coordinate &Player::getCoord() const {
    return coordinate;
}

int Player::getHP() const {
    return HP;
}

Team Player::getTeam() const {
    return team;
}

std::string Player::getBoardID() {
    return std::__cxx11::string();
}

std::vector<Goal> Player::getGoalPriorityList() {
    return priorities;
}

const std::string Player::getClassAbbreviation() const {
    return abbreviation;
}

bool Player::attack(Player *enemy) {
    enemy->HP -= attackDamage;
    return enemy->isDead();
}

void Player::heal(Player *ally) {
    ally->HP += healPower;
    if (ally->HP > ally->maxHP)
        ally->HP = ally->maxHP;
}

void Player::movePlayerToCoordinate(Coordinate c) {

}

bool Player::isDead() const {
    return HP <= 0;
}
