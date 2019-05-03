#include "Championship.h"
#include "Utilizer.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/
Championship::Championship() {

}

Championship::Championship(const Championship &rhs) {
    for (Race r : rhs.races) {
        this->races.push_back(r);
    }
}

Championship::~Championship() {
    
}

void Championship::addNewRace(Race &race) {
    races.push_back(race);
}

void Championship::addNewRace(std::string race_name) {
    Race* newRace = new Race(race_name);
    newRace->setAverageLaptime(Utilizer::generateAverageLaptime()),
    races.push_back(*newRace);
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
