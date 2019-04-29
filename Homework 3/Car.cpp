#include "Car.h"
#include "Utilizer.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE 
*/

Car::Car(std::string driver_name) : 
    driver_name(driver_name),
    performance(Utilizer::generatePerformance()),
    head(nullptr),//?
    next(nullptr) {
}

Car::Car(const Car& rhs) {
    driver_name = rhs.driver_name;
    performance = rhs.performance;
    
}


