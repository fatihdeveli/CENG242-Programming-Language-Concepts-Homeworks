#include"Board.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Board::Board(uint _size, std::vector<Player *> *_players, Coordinate chest) :
size(_size), players(_players), chest(chest) {

}

Board::~Board() = default;

bool Board::isCoordinateInBoard(const Coordinate &c) {
    return c.x >= 0 && c.x < size && c.y >= 0 && c.y < size;
}

bool Board::isPlayerOnCoordinate(const Coordinate &c) {
    for (Player* p : *players) {
        if (p == nullptr) continue;
        if (p->getCoord() == c)
            return true;
    }
    return false;
}

Player *Board::operator[](const Coordinate &c) {
    for (Player* p : *players) {
        if (p == nullptr) continue;
        if (p->getCoord() == c) {
            return p;
        }
    }
    return nullptr;
}

Coordinate Board::getChestCoordinates() {
    return chest;
}

void Board::printBoardwithID() {
    // Build a grid and place the players to the grid to
    // access them quickly for printing.
    Player* grid[size][size];
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            grid[i][j] = nullptr;
        }
    }
    for (Player* p : *players) {
        if (p == nullptr) continue; // Dead players
        grid[p->getCoord().y][p->getCoord().x] = p;
    }

    for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
            Player* p = grid[y][x];
            if (p) {
                std::cout << p->getBoardID() << " ";
            }
            else if (chest == Coordinate(x, y)) {
                std::cout << "Ch ";
            }
            else {
                std::cout << "__ ";
            }
        }
        std::cout << std::endl;
    }
}

void Board::printBoardwithClass() {
    // Build a grid and place the players to the grid to
    // access them quickly for printing.
    Player* grid[size][size];
    for (int i = 0; i < size; i++) {
        for (int j = 0; j < size; j++) {
            grid[i][j] = nullptr;
        }
    }
    for (Player* p : *players) {
        if (p == nullptr) continue; // Dead players
        grid[p->getCoord().y][p->getCoord().x] = p;
    }

    for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
            Player* p = grid[y][x];
            if (p) {
                std::cout << p->getClassAbbreviation() << " ";
            }
            else if (chest == Coordinate(x, y)) {
                std::cout << "Ch ";
            }
            else {
                std::cout << "__ ";
            }
        }
        std::cout << std::endl;
    }
}

void Board::setPlayers(std::vector<Player*>* p) {
    players = p;
}

Player *Board::getPlayerOnCoordinate(const Coordinate &c) {
    for (Player* p : *players) {
        if (p == nullptr) continue;
        if (p->getCoord() == c)
            return p;
    }
    return nullptr;
}
