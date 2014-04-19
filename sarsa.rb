#!/usr/bin/env ruby -wKU

require 'CSV'

class Sarsa
  REWARD_VALUE = 1.0

  def initialize(map_path, qtable_path)
    @Map = 
      if map_path.nil?
        Array.new(20) { #fixme no starting locations
          i = 20
          Array.new(20) {
            'X'
          }
        }
      else
        CSV.read map_path
      end

    @QTable = 
      if qtable_path.nil?
        Array.new(@Map.length) { Array.new(@Map[0].length) { 1.0 } }
      else
        CSV.read qtable_path
      end
  end
  
  def to_s
    @Map.map{|row| "|"+row.join("|")+"|" }.join("\n")
  end

  def to_csv
    @Map.map{|row| row.join(" ") }.join("\n")
  end
  
end