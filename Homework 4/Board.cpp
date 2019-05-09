#include"Board.h"

/*
YOU MUST WRITE THE IMPLEMENTATIONS OF THE REQUESTED FUNCTIONS
IN THIS FILE. START YOUR IMPLEMENTATIONS BELOW THIS LINE
*/
Board::Board(uint _size, std::vector<Player *> *_players, Coordinate chest) :
size(_size), players(_players), chest(chest) {

}

Board::~Board() {
}

bool Board::isCoordinateInBoard(const Coordinate &c) {
    return c.x >= 0 && c.x < size && c.y >= 0 && c.y < size;
}

bool Board::isPlayerOnCoordinate(const Coordinate &c) {
    for (Player* p : *players) {
        if (p->getCoord() == c)
            return true;
    }
    return false;
}

Player *Board::operator[](const Coordinate &c) {
    for (Player* p : *players) {
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
        grid[p->getCoord().y][p->getCoord().x] = p;
    }

    for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
            if (chest == Coordinate(x, y)) {
                std::cout << "Ch ";
                continue;
            }
            Player* p = grid[y][x];
            if (p == nullptr) {
                std::cout << "__ ";
            }
            else {
                int id = p->getID();
                if (id < 10)
                    std::cout << 0;
                std::cout << id << " ";
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
        grid[p->getCoord().y][p->getCoord().x] = p;
    }

    for (int y = 0; y < size; y++) {
        for (int x = 0; x < size; x++) {
            if (chest == Coordinate(x, y)) {
                std::cout << "Ch ";
                continue;
            }
            Player* p = grid[y][x];
            if (p == nullptr) {
                std::cout << "__ ";
            }
            else {
                std::cout << p->getClassAbbreviation() << " ";
            }
        }
        std::cout << std::endl;
    }
}

std::vector<Player*>* Board::getPlayers() {
    return players;
}
