#include "Laptime.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/
Laptime::Laptime(int laptime) : laptime(laptime), next(nullptr) {

}

Laptime::Laptime(const Laptime &rhs) {

}

Laptime::~Laptime() {

}

void Laptime::addLaptime(Laptime *next) {

}

bool Laptime::operator<(const Laptime &rhs) const {
    return false;
}

bool Laptime::operator>(const Laptime &rhs) const {
    return false;
}

Laptime &Laptime::operator+(const Laptime &rhs) {
    return <#initializer#>;
}

std::ostream &operator<<(std::ostream &os, const Laptime &laptime) {
    return <#initializer#>;
}
