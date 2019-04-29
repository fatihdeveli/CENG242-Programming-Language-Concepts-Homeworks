#include "Championship.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/
Championship::Championship() {

}

Championship::Championship(const Championship &rhs) {

}

Championship::~Championship() {

}

void Championship::addNewRace(Race &race) {

}

void Championship::addNewRace(std::string race_name) {

}

void Championship::removeRace(std::string race_name) {

}

void Championship::addLap(std::string race_name) {

}

Race Championship::operator[](std::string race_name) {
    return Race("none");
}

std::ostream &operator<<(std::ostream &os, const Championship &championship) {
    return os;
}
