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
    if (id < 10) {
        return "0" + std::to_string(id);
    }
    else {
        return std::to_string(id);
    }
}

std::vector<Goal> Player::getGoalPriorityList() {
    return priorities;
}

const std::string Player::getClassAbbreviation() const {
    return abbreviation;
}

bool Player::attack(Player *enemy) {
    enemy->HP -= attackDamage;
    std::cout << "Player " << getBoardID() << " attacked Player "
        << enemy->getBoardID() << " (" << attackDamage << ")" << std::endl;
    return enemy->isDead();
}

void Player::heal(Player *ally) {
    ally->HP += healPower;
    if (ally->HP > ally->maxHP)
        ally->HP = ally->maxHP;
    std::cout << "Player " << getBoardID() << " healed Player "
        << ally->getBoardID() << std::endl;
}

void Player::movePlayerToCoordinate(Coordinate c) {
    std::cout << "Player " << getBoardID() << " moved from (" << coordinate.x
        << "/" << coordinate.y << ") to (" << c.x << "/" << c.y << ")" << std::endl;
    coordinate = c;
}

bool Player::isDead() const {
    return HP <= 0;
}
