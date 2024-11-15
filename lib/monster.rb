# frozen_string_literal: true

require_relative 'character'

# parent class for all monsters
class Monster < Character
  SLOWDOWN = 20

  def initialize(window)
    super(window)

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

  private

  def set_default_position(x_offset: 0, y_offset: 0)
    @x = @window.width + x_offset
    @y = @window.ground + y_offset
  end
end

# ground enemy
class Octorok < Monster
  def initialize(window)
    super(window)

    @width = 100
    @height = 79

    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/octorok_red.png', @width, @height, true
    )

    set_default_position(y_offset: 20)
  end

  def reset
    set_default_position(y_offset: 20)
  end
end

# flying enemy
class Keese < Monster
  def initialize(window)
    super(window)

    @width = 76
    @height = 72

    @sprites = Gosu::Image.load_tiles(
      @window, 'assets/keese.png', @width, @height, true
    )

    set_default_position(y_offset: -150)
  end

  def reset
    set_default_position(y_offset: -150)
  end
end
