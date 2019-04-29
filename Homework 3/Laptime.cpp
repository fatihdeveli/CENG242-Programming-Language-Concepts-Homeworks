#include "Laptime.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/
Laptime::Laptime(int laptime) : laptime(laptime), next(nullptr) {

}

Laptime::Laptime(const Laptime &rhs) : laptime(rhs.laptime), next(nullptr) {
}

Laptime::~Laptime() {

}

void Laptime::addLaptime(Laptime *next) {
    next = next;
}

bool Laptime::operator<(const Laptime &rhs) const {
    return laptime < rhs.laptime;
}

bool Laptime::operator>(const Laptime &rhs) const {
    return laptime > rhs.laptime;
}

Laptime &Laptime::operator+(const Laptime &rhs) {
    laptime += rhs.laptime;
    return *this;
}

std::ostream &operator<<(std::ostream &os, const Laptime &laptime) {
    int time = laptime.laptime;
    os << time / 60000 << ":" << (time/1000) % 60 << "." << time % 1000;
    return os;
}
