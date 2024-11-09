# frozen_string_literal: true

require_relative 'character'

class Keese < Character
  SLOWDOWN = 20

  def initialize(window)
    super(window)

    @window = window

    @width = 76
    @height = 72

    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/keese.png', @width, @height, true
    )

    @x = @window.width
    @y = @window.bottom - 150

    @facing = :left
  end

  def update
    @x = @window.width + 50 if @x < -100
    @x -= @window.speed
  end

  def draw
    f = (@window.frame / SLOWDOWN) % 4 # @sprites.size

    image = @sprites[f]

    image.draw(@x, @y, 1)
  end

  def reset
    @x = @window.width
    @y = @window.bottom - 150
  end
end
