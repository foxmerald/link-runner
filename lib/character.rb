# frozen_string_literal: true

# Parent class for all moving characters in the game
class Character
  attr_accessor :x, :y, :width, :height, :facing

  include Coords

  def initialize(window)
    @window = window
  end
end
