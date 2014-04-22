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
    @Origin = @Map.each_index { |i| j = a[i].index 'O'; Coord.new(j,i) if j }
  end
  
  def to_s
    @Map.map{|row| row.join(" ") }.join("\n")
  end

  def to_csv
    @Map.map{|row| row.join(",") }.join("\n")
  end

  # def [](coord)
  #   raise TypeError, "Coordinate-like argument expected" 
  #     unless coord.respond_to? :x and coord.respond_to? :y
  #   @Map.[coord.y][coord.x]
  # end

  def action_policy(coord)
    return nil if self.Map[coord.y][coord.x] == 'X'

    actions = [
      Coord.new(coord.x+1, coord.y)
      Coord.new(coord.x-1, coord.y)
      Coord.new(coord.x, coord.y+1)
      Coord.new(coord.x, coord.y-1)
    ]

    actions.reject! { |c| 
      if @Map[c.y].nil? || @Map[c.y][c.x].nil?
        true
      elsif @Map[c.y][c.x] == '*'
        true
      else
        false
      end
    }

    actions.sort { |a, b| 
      @QTable[a.y][a.x] <=> @QTable[b.y][b.x]
    }[0]
  end

  def sarsa(coord = self.Origin)
    action = action_policy(coord)
    if action.nil?
      return ENDPOINT_VALUE
    end
    
    q_i = self.QTable[coord.y][coord.x]
    
    r_1 = reward_value(action)
    next_q = DISCOUT_FACTOR * sarsa(action)

    self.QTable[coord.y][coord.x] =
      q_i + (LEARNING_RATE * (r_1 + next_q - q_i))

    # TODO: Log all qtable data here
  end
end

binding.pry