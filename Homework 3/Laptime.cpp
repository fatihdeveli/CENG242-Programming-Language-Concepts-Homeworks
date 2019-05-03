#include <iostream>
#include <zconf.h>
#include "Laptime.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/
Laptime::Laptime(int laptime) : laptime(laptime), next(nullptr) {

}

Laptime::Laptime(const Laptime &rhs) : laptime(rhs.laptime), next(nullptr) {
}

Laptime::~Laptime() = default;

void Laptime::addLaptime(Laptime *nextLap) {
    next = nextLap;
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
    os << time / 60000 << ":";
    std::string seconds = std::to_string((time/1000) % 60);
    seconds = std::string(2-seconds.size(), '0').append(seconds);
    std:: string milliseconds = std::to_string(time%1000);
    milliseconds = std::string(3-milliseconds.size(), '0').append(milliseconds);
    os << seconds << "." << milliseconds;
    return os;
}

int Laptime::getLaptime() const {
    return laptime;
}

Laptime *Laptime::getNext() const {
    return next;
}
