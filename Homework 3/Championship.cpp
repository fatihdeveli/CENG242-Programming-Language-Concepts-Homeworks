#include "Championship.h"
#include "Utilizer.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/
Championship::Championship() {

}

Championship::Championship(const Championship &rhs) {
    races = rhs.races;
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
    for (Race r : races) {
        if (r.getRaceName() == race_name) {
            ++r;
        }
    }
}

Race Championship::operator[](std::string race_name) {
    for (Race r : races) {
        if (r.getRaceName() == race_name) {
            return r;
        }
    }
    return Race("none");
}

std::ostream &operator<<(std::ostream &os, const Championship &championship) {
    os << "Championship Results" << std::endl;
    
    return os;
}
