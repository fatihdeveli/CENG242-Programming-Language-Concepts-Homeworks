#include "Race.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/
Race::Race(std::string race_name) : average_laptime(-1) {

}

Race::Race(const Race &rhs) : average_laptime(-1) {

}

Race::~Race() {

}

std::string Race::getRaceName() const {
    return std::__cxx11::string();
}

void Race::addCartoRace() {

}

void Race::addCartoRace(Car &car) {

}

int Race::getNumberOfCarsinRace() {
    return 0;
}

void Race::goBacktoLap(int lap) {

}

void Race::operator++() {

}

void Race::operator--() {

}

Car Race::operator[](const int car_in_position) {
    return Car("none");
}

Car Race::operator[](std::string driver_name) {
    return Car("none");
}

Race &Race::operator=(const Race &rhs) {
    return *this;
}

std::ostream &operator<<(std::ostream &os, const Race &race) {
    return os;
}
