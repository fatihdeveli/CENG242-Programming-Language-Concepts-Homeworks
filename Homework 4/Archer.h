#ifndef HW4_ARCHER_H
#define HW4_ARCHER_H

#include"Player.h"

class Archer : public Player{
  /**
   * Attack damage 50
   * Heal power 0
   * Max HP 200
   * Goal Priorities -> {ATTACK}
   * Class abbreviation -> "ar" or "AR"
   * Not able to move at all.
   * Can attack to a range of 2 squares directly up, down, left or right, from
   * its coordinate.
   *
   */

public:
    Archer(uint id, int x, int y, Team team);
    int getAttackDamage() const override;
    int getHealPower() const override;
    int getMaxHP() const override;
    std::vector<Goal> getGoalPriorityList() override;
    const std::string getClassAbbreviation() const override;
    std::vector<Coordinate> getAttackableCoordinates() override;
    std::vector<Coordinate> getMoveableCoordinates() override;
    std::vector<Coordinate> getHealableCoordinates() override;
};

#endif
