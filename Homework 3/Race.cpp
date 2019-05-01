#include "Race.h"
#include "Utilizer.h"
#include <tuple>

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/
Race::Race(std::string race_name) : average_laptime(Utilizer::generateAverageLaptime()){
    this->race_name = race_name;
    head = nullptr;
    numberOfCarsInRace = 0;
}

Race::Race(const Race &rhs) : average_laptime(rhs.average_laptime) {
    race_name = rhs.race_name;
    numberOfCarsInRace = rhs.numberOfCarsInRace;

    for (Car* temp = rhs.head; temp; temp = temp->getNext()) {
        addCartoRace(*temp); // Creates a copy of the given car and adds to the race.
    }

}

Race::~Race() {
    while(head) {
        auto nextCar = head->getNext();
        delete head;
        head = nextCar;
    }
}

std::string Race::getRaceName() const {
    return race_name;
}

void Race::addCartoRace() {
    std::string name = "dummy", surname = "dummy";
    static const char characters[] = "abcdefghijklmnopqrstuvwxyz";

    for (int i = 0; i < 5; ++i) {
        name[i] = characters[rand() % (sizeof(characters) - 1)];
        surname[i] = characters[rand() % (sizeof(characters) - 1)];
    }
    auto *newCar = new Car(name + " " + surname);

    if (head == nullptr) {
        head = newCar;
    }
    else {
        auto temp = head;
        while (temp->getNext())
            temp = temp->getNext();
        temp->addCar(newCar);
    }

    numberOfCarsInRace++;
}

void Race::addCartoRace(Car &car) {
    auto *newCar = new Car(car.getName());
    newCar->setPerformance(car.getPerformance());
    if (head == nullptr) {
        head = newCar;
    }
    else {
        auto temp = head;
        while (temp->getNext())
            temp = temp->getNext();
        temp->addCar(newCar);
    }
    numberOfCarsInRace++;
}

int Race::getNumberOfCarsinRace() {
    return numberOfCarsInRace;
}

void Race::goBacktoLap(int lap) {
    Car* tempCar = head;
    while (tempCar) {
        Laptime* lastElement = nullptr;
        Laptime* tempLap = tempCar->getHead();
        for (int i = 0; i < lap; i++) { // Leave the first 'lap' elements
            auto next = tempLap->getNext();
            if (next == nullptr) {
                lastElement = tempLap; // Last element's next should be set as nullptr
            }
            tempLap = next;
        }

        while (tempLap) { // Clean up the rest
            Laptime* temp = tempLap;
            tempLap = tempLap->getNext();
            delete temp;
        }

        if (lastElement)
            lastElement->addLaptime(nullptr);

        tempCar = tempCar->getNext();
    }

}

void Race::operator++() {
    Car* temp = head;
    while (temp) {
        temp->Lap(average_laptime);
        temp = temp->getNext();
    }
    // TODO: sort
}

void Race::operator--() {

    // TODO: sort

}

Car Race::operator[](const int car_in_position) {
    Car* temp = head;
    for (int i = 0; i < car_in_position; i++)
        temp = temp->getNext();

    return *temp;
}

Car Race::operator[](std::string driver_name) {
    Car* temp = head;
    while (temp) {
        if (temp->getName() == driver_name)
            return *temp;
        temp = temp->getNext();
    }
    return Car("error");
}

Race &Race::operator=(const Race &rhs) {
    if (this != &rhs) {




    }
    return *this;
}

std::ostream &operator<<(std::ostream &os, const Race &race) {
    const static int points[10] = {25,18,15,12,10,8,6,4,2,1};
    Car* temp = race.head;
    int position = 1;

    while (temp) {
        int positionDigits = std::to_string(race.numberOfCarsInRace).size();
        for (int i = 1; i < positionDigits; i++) { // Add leading zeros to position
            if (position < pow(10, i)) {
                os << "0";
            }
        }
        os << position << "--" << *temp;

        if (position <= 10)
            os << "--" << points[position-1];

        os << std::endl;
        temp = temp->getNext();
        position++;
    }
/*
    // Find the fastest lap & the position of the car
    temp = race.head;
    Laptime fastest(INT32_MAX);
    std::tuple<Laptime*, int> fastestLap(&fastest, -1);
    position = 1;
    while (temp) {
        if temp->

        temp = temp->getNext();
        position++;
    }
*/

    return os;
}
