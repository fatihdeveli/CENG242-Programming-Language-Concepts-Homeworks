#ifndef HW4_PRIEST_H
#define HW4_PRIEST_H

#include"Player.h"

class Priest : public Player{
  /**
   * Attack damage 0
   * Heal power 50
   * Max HP 150
   * Goal Priorities -> {HEAL,TO_ALLY,CHEST} in decreasing order
   * Class abbreviation -> "pr" or "PR"
   * Can move to all adjacent squares, including diagonals.
   * Can heal all adjacent squares, including diagonals.
   *
   */

public:
    Priest(uint id, int x, int y, Team team);
    int getAttackDamage() const override;
    int getHealPower() const override;
    int getMaxHP() const override;
    std::vector<Goal> getGoalPriorityList() override;
    const std::string getClassAbbreviation() const override;
    std::vector<Coordinate> getAttackableCoordinates() override;
    std::vector<Coordinate> getMoveableCoordinates() override;
    std::vector<Coordinate> getHealableCoordinates() override;

private:

};

#endif
