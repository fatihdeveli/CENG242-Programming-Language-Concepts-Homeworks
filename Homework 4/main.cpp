#include <iostream>
#include "Board.h"
#include "Archer.h"

int main() {
    std::vector<Player*> players;
    Archer a(28, 5, 5, KNIGHTS);
    players.push_back(&a);
    Board b(6, &players, Coordinate(3,4));
    b.printBoardwithID();
    std::cout << std::endl;
    b.printBoardwithClass();
    return 0;
}