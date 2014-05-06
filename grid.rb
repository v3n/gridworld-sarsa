#!/usr/bin/env ruby -wKU

require 'csv'
require 'pry'

class Grid < Array
  def initialize(arg)
    if File.file? arg.to_s
      super CSV.read(arg)
    elsif arg.is_a? Numeric
      super(arg) {
        Array.new(arg) {
          yield
        }
      }
    elsif arg.is_a? Array
      super arg
    else
      raise TypeError.new "Unrecognized for constructor"
    end
  end

  def [](coord)
    # super(coord) unless coord.respond_to? :x and coord.respond_to? :y
    super(coord.y)[coord.x]
  end

  def []=(*args)
    # super unless args[0].respond_to? :x and args[0].respond_to? :y
    Array.instance_method(:[]).bind(self).call(args[0].y)[args[0].x] = args[1]
    # super(args[0].y)[args[0].x] = args[1]
  end

  def new_qtable()
      Grid.new(Array.new(20) { Array.new(20) { 
        rand 0..0.01
      }})
  end

  def new_rewardtable()
      map = self.to_a
      a = Array.new(20) { Array.new(20, 0) }
      map.each_index { |y| 
        map[y].each_with_index { |val, x| 
          a[y][x] = ((val == 'X') ? 1 : 0)
        }
      }
      return Grid.new(a)
  end
  
end

# binding.pry