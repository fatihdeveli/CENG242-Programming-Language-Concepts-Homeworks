#include "Car.h"
#include "Utilizer.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/

Car::Car(std::string driver_name) {
    performance = Utilizer::generatePerformance();
    this->driver_name = driver_name;
    head = nullptr;
    next = nullptr;
}

Car::Car(const Car& rhs) {
    driver_name = rhs.driver_name;
    performance = rhs.performance;

    if (rhs.head) {
        Laptime const *temp = rhs.head;
        auto *laptime = new Laptime(*rhs.head);
        head = laptime;
        while ((temp = temp->getNext())) {
            laptime->addLaptime(new Laptime(*temp));
            laptime = laptime->getNext();
        }
    }
    else {
        head = nullptr;
    }
    next = nullptr;
}

Car::~Car() {
    while(head) {
        auto nextLapTime = head->getNext();
        delete head;
        head = nextLapTime;
    }
}

std::string Car::getDriverName() const {
    return driver_name;
}

double Car::getPerformance() const {
    return performance;
}

void Car::addCar(Car *nextCar) {
    next = nextCar;
}

bool Car::operator<(const Car &rhs) const {
    int totalLaptime1 = 0, totalLaptime2 = 0;
    for (auto temp = head; temp; temp = temp->getNext()) {
        totalLaptime1 += temp->getLaptime();
    }
    for (auto temp = rhs.head; temp; temp = temp->getNext()) {
        totalLaptime2 += temp->getLaptime();
    }
    return totalLaptime1 < totalLaptime2;
}

bool Car::operator>(const Car &rhs) const {
    int totalLaptime1 = 0, totalLaptime2 = 0;
    for (auto temp = head; temp; temp = temp->getNext()) {
        totalLaptime1 += temp->getLaptime();
    }
    for (auto temp = rhs.head; temp; temp = temp->getNext()) {
        totalLaptime2 += temp->getLaptime();
    }
    return totalLaptime1 > totalLaptime2;
}

Laptime Car::operator[](const int lap) const {
    if (lap < 0)
        return Laptime(0);

    Laptime* temp = head;
    for (int i = 0; i < lap && temp; i++, temp = temp->getNext());

    if (temp) {
        return *temp;
    }
    return Laptime(0);
}

void Car::Lap(const Laptime &average_laptime) {
    int time = average_laptime.getLaptime() + Utilizer::generateLaptimeVariance(performance);
    auto *laptime = new Laptime(time);
    if (head == nullptr) {
        head = laptime;
    }
    else {
        auto temp = head;
        while (temp->getNext())
            temp = temp->getNext();
        temp->addLaptime(laptime);
    }
}

std::ostream &operator<<(std::ostream &os, const Car &car) {
    std::string name = car.driver_name;
    name = name.substr(name.find(' ') + 1);

    name = name.substr(0, 3); // Get the first 3 letters
    for (int i = 0; i < 3; i++) { // Capitalize
        name[i] = toupper(name[i]);
    }

    os << name << "--";

    Laptime fastest(INT32_MAX), slowest(0), total(0);

    for (Laptime* temp = car.head; temp; temp = temp->getNext()) {
        if (*temp < fastest)
            fastest = *temp;
        if (*temp > slowest)
            slowest = *temp;
        total = total + *temp;
    }

    os << slowest << "--" << fastest << "--" << total;

    return os;
}

Car *Car::getNext() const {
    return next;
}

Laptime *Car::getHead() const {
    return head;
}

void Car::setHead(Laptime *head) {
    Car::head = head;
}

std::string Car::getName() {
    return driver_name;
}

void Car::setPerformance(double performance) {
    this->performance = performance;
}

void Car::setName(const std::string& name) {
    driver_name = name;
}

unsigned int Car::totalLapTime() {
    unsigned int total = 0;
    for (Laptime* i = head; i; i = i->getNext()) {
        total += i->getLaptime();
    }
    return total;
}

