#!/usr/bin/env ruby

require 'CSV'
require 'pry'

Coord = Struct.new(:x, :y)

class Sarsa
  REWARD_VALUE = 0.1
  ENDPOINT_VALUE = 1.0
  DISCOUT_FACTOR = 0.5
  LEARNING_RATE = 0.5

  def initialize(map, qtable)
    @Map = map
    @QTable = qtable
  end
  
  def to_s
    @Map.map{|row| "|"+row.join("|")+"|" }.join("\n")
  end

  def to_csv
    @Map.map{|row| row.join(" ") }.join("\n")
  end

  # def [](coord)
  #   raise TypeError, "Coordinate-like argument expected" 
  #     unless coord.respond_to? :x and coord.respond_to? :y
  #   @Map.[coord.y][coord.x]
  # end

  def action_policy(coord)
    return nil
  end

  def sarsa(coord)
    action = action_policy(coord)
    if action.nil?
      return REWARD_VALUE
    end
    
    q_i = self.QTable[coord.y][coord.x]
    
    q_i + (LEARNING_RATE * (reward_value(action) + ))
    r_1 = reward_value(action)
    next_q = DISCOUT_FACTOR * sarsa(action)

    self.QTable[coord.y][coord.x] =
      q_i + (LEARNING_RATE * (r_1 + next_q - q_i))

    # TODO: Log all qtable data here
  end
end

binding.pry