  #!/usr/bin/env ruby

require 'CSV'
require 'pry'
require './grid'

Coord = Struct.new(:x, :y)

class Sarsa
  attr_accessor :Map, :QTable, :explore_chance, :Rewards
  attr_reader :Origin

  REWARD_VALUE = 0.1
  ENDPOINT_VALUE = 1.0
  DISCOUT_FACTOR = 0.5
  LEARNING_RATE = 0.5

  INITIAL_EXPLORE = 0.8
  ENDING_EXPLORE = 0.1

  lmbda = 0.9

  def initialize()
    @Map = CSV.read("/Users/jonathan/Development/ai/sarsa/demo_map.csv")
    @QTable = Array.new(20) { 
      Array.new(20) { 
        rand 0..0.01
    }}
    @Map.each_index { |i| j = self.Map[i].index 'O'; @Origin = Coord.new(j,i) if j }
    @Rewards = Array.new(20) { |y|
      Array.new(20) { |x|
        case @Map[y][x]
        when 'X'
          ENDPOINT_VALUE
        when '*'
          0
        else
          REWARD_VALUE
        end 
      }
    }
    self.explore_chance = INITIAL_EXPLORE
  end

  def to_s
    @Map.map{|row| row.join(" ") }.join("\n")
  end

  def to_csv
    @QTable.map{|row| row.join(",") }.join("\n")
  end

  def get_actions(coord)
    return nil if self.Map[coord.y][coord.x] == 'X'

    actions = [
      Coord.new(coord.x+1, coord.y),
      Coord.new(coord.x-1, coord.y),
      Coord.new(coord.x, coord.y+1),
      Coord.new(coord.x, coord.y-1)
    ]

    actions.reject! { |c| 
      if @Map[c.y].nil? || @Map[c.y][c.x].nil?
        true
      elsif c.y < 0 || c.x < 0
        true
      elsif @Map[c.y][c.x] == '*'
        true
      else
        false
      end
    }

    actions.sort! { |a, b| 
      @QTable[a.y][a.x] <=> @QTable[b.y][b.x]
    }
  end

  def sarsa()
    elig_trace = Array.new()

    q_1 = ENDPOINT_VALUE
    coord = self.Origin

    #generate all moves
    puts self.to_csv
    begin
      actions = get_actions(coord)

      break if actions.nil?

      #explore/exploitation
      action = if rand < explore_chance 
          elig_trace.clear ; actions[rand actions.size]
        else
          actions[0]
        end

      elig_trace << action

      elig_trace.reverse!.each_with_index do |a, i|
        # break if i == elig_trace.size - 1
        action_1 = elig_trace[i + 1] || coord

        r_1 = self.Rewards[a.y][a.x]
        q_i = (action_1.nil?) ? 0 : self.QTable[action_1.y][action_1.x]
        q_1 = self.QTable[a.y][a.x]

        delta = r_1 + (DISCOUT_FACTOR * q_1) - q_i
        self.QTable[a.y][a.x] = self.QTable[action_1.y][action_1.x] + (LEARNING_RATE * delta)
      end

      coord = action
    end while not actions.nil?
    puts ""
    puts self.to_csv
  end

  # def sarsa(n = 100, coord = self.Origin)
  #   EXPLORE_DISCOUNT = (INITIAL_EXPLORE - 0.1) / n
  #   explore_chance = INITIAL_EXPLORE

  #   while i < n
  #     actions = get_actions(coord)
  #     if actions.empty?
  #       coord = self.Origin; next
  #     end

  #     #explore/exploitation
  #     action = if rand < explore_chance 
  #         actions[rand actions.size]
  #       else
  #         actions[0]
  #       end

  #     #reward value
  #     r_1 = (@Map[action.y][action.x] == 'X') ? ENDPOINT_VALUE : REWARD_VALUE 

  #     q_i = self.QTable[coord.y][coord.x]
  #     q_1 = self.QTable[actions[0].y][actions[0].x]
      
  #     next_q = DISCOUT_FACTOR * q_1

  #     self.QTable[coord.y][coord.x] =
  #       q_i + (LEARNING_RATE * (r_1 + next_q - q_i))

  #     explore_chance -= EXPLORE_DISCOUNT
  #     coord = action

  #     # TODO: Log all qtable data here
  #     puts i+"\n"+self.to_csv
  #   end
  # end
  
  # def sarsa (n = 5000, coord = self.Origin, delta = nil)
  #   delta = reward_next + sarsa(n - 1) - self.QTable[coord]
  #   self.QTable[coord] = reward_next +   
  # end
end

binding.pry
