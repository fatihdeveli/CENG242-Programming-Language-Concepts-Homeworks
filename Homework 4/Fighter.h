#ifndef HW4_FIGHTER_H
#define HW4_FIGHTER_H

#include"Player.h"

class Fighter : public Player{
  /**
   * Attack damage 100
   * Heal power 0
   * Max HP 400
   * Goal Priorities -> {ATTACK,TO_ENEMY,CHEST} in decreasing order
   * Class abbreviation -> "fi" or "FI"
   * Can move to adjacent up, down, left or right square
   * Can attack to adjacent up, down, left or right square
   *
   */

public:
    Fighter(uint id, int x, int y, Team team);
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
