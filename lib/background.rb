# frozen_string_literal: true

require 'gosu'

# moving background image
class Background
  attr_accessor :x, :y, :width, :height

  SLOWDOWN = 20

  def initialize(window)
    @window = window

    @background = Gosu::Image.new('assets/sprites/background.png')

    @x = 0
    @y = 0
  end

  def update
    @x -= @window.speed / 4.0
  end

  def draw
    # Ensure background loops smoothly without gaps
    bg_width = @background.width
    offset_x = (@x % bg_width).round

    @background.draw(offset_x, @y, 0)
    @background.draw(offset_x - bg_width, @y, 0)
    @background.draw(offset_x + bg_width, @y, 0)
  end
end
