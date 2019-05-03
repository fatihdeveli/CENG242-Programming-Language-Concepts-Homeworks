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
        // Copy the car without the laps
        Car* newCar = new Car(temp->getName());
        newCar->setPerformance(temp->getPerformance());
        newCar->setInternal(temp->isInternal());

        addCartoRace(*temp);
    }
}

Race::~Race() {
    while(head) {
        auto nextCar = head->getNext();
        if (head->isInternal()) {
            delete head;
        }
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
    newCar->setInternal(true); // Car was created internally, let the
    // destructor know this car should be deleted.

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
    if (head == nullptr) {
        head = &car;
    }
    else {
        auto temp = head;
        while (temp->getNext())
            temp = temp->getNext();
        temp->addCar(&car);
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
/*
        while (tempLap) { // Clean up the rest
            Laptime* temp = tempLap;
            tempLap = tempLap->getNext();
            delete temp;
        }
*/
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
    sortCars();
}

void Race::operator--() {
    // Delete the last lap of cars, and sort them again.
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
    return *this;
}

std::ostream &operator<<(std::ostream &os, const Race &race) {
    const static int points[10] = {25,18,15,12,10,8,6,4,2,1};
    Car* tempCar;
    int position;
    int fastestLapPosition = race.carPositionWithFastestLap();

    position = 1;
    for (tempCar = race.head; tempCar; tempCar = tempCar->getNext()) {
        int positionDigits = std::to_string(race.numberOfCarsInRace).size();
        for (int i = 1; i < positionDigits; i++) { // Add leading zeros to position
            if (position < pow(10, i)) {
                os << "0";
            }
        }
        os << position << "--" << *tempCar;

        if (position <= 10)
            os << "--" << points[position-1];
        if (position == fastestLapPosition) {
            os << "--" << 1;
        }

        os << std::endl;
        position++;
    }
    return os;
}

void Race::swapCars(Car *car1, Car *car2) {
    std::string tempName = car1->getName();
    car1->setName(car2->getName());
    car2->setName(tempName);

    double performance = car1->getPerformance();
    car1->setPerformance(car2->getPerformance());
    car2->setPerformance(performance);

    Laptime* laptimes = car1->getHead();
    car1->setHead(car2->getHead());
    car2->setHead(laptimes);
}

void Race::sortCars() {
    if (head == nullptr)
        return;
    bool swapped = true;
    Car* end = nullptr;
    while (swapped) {
        swapped = false;
        Car* current = head;
        while (current != end && current->getNext()) {
            if (current->totalLapTime() > current->getNext()->totalLapTime()) {
                swapped = true;
                swapCars(current, current->getNext());
            }
            current = current->getNext();
        }
        end = current;
    }
}

std::ostream &Race::raceWinner(std::ostream& os) {
    std::string name = (head->getName()).substr(0,3); // Get the first 3 letters
    for (int i = 0; i < 3; i++) { // Capitalize
        name[i] = toupper(name[i]);
    }
    os << name << "--";

    
}

void Race::setAverageLaptime(int time) {
    average_laptime.setLaptime(time);
}


// Find the position of the car with fastest lap
int Race::carPositionWithFastestLap() const {
    int carPositionWithFastestLap = -1;
    Laptime fastest(INT32_MAX);
    int position = 1;
    for (Car* tempCar = head; tempCar; tempCar = tempCar->getNext()) {
        for (Laptime* tempLap = tempCar->getHead(); tempLap; tempLap = tempLap->getNext()) {
            if (*tempLap < fastest) {
                fastest = *tempLap;
                carPositionWithFastestLap = position;
            }
        }
        position++;
    }
    return carPositionWithFastestLap;
}
